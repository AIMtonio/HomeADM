
-- SP PLDOPEINTERPREOALT

DELIMITER ;
DROP PROCEDURE IF EXISTS PLDOPEINTERPREOALT;

DELIMITER $$
CREATE PROCEDURE `PLDOPEINTERPREOALT`(
	Par_CatProcedIntID		VARCHAR(10),	-- Procedimiento Interno.
	Par_CatMotivPreoID		VARCHAR(15),	-- Motivo Preocupante.
	Par_FechaDeteccion		DATE,			-- Fecha de Detección (fecha del sistema).
	Par_ClavePersonaInv		INT,			-- ID del empleado.
	Par_NomPersonaInv		VARCHAR(100),	-- Nombre del empreado.

	Par_CteInvolucrado		VARCHAR(100),	-- Nombre del cliente involucrado.
	Par_Frecuencia			CHAR(1),		-- Indica si existe o no Frecuencia.
	Par_DesFrecuencia		VARCHAR(50),	-- Descripción de la Frecuencia.
	Par_DesOperacion		VARCHAR(300),	-- Descripción de la Operación.
	Par_Salida				CHAR(1),		-- Indica el tipo de salida S.- Si N.- No

	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	Var_OpeInterPreoID	INT;
	DECLARE	Var_ClaveRegistra	CHAR(2);
	DECLARE	Var_NombreReg		VARCHAR(35);
	DECLARE	Var_SucursalID		INT;
	DECLARE	Var_CatMotivPreoID	VARCHAR(15);
	DECLARE	Var_CatProcedIntID	VARCHAR(10);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE	Estatus_C		CHAR(1);
	DECLARE	Tipo_Persona	INT;
	DECLARE	Tipo_IntPreo	INT;
	DECLARE Str_SI			CHAR(1);
	DECLARE Str_NO			CHAR(1);

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Estatus_C			:= '1';
	SET	Tipo_IntPreo		:= 03;
	SET	Str_SI				:= 'S';
	SET	Str_NO				:= 'N';
	SET	Var_ClaveRegistra	:= '1';
	SET	Var_NombreReg		:= NULL;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDOPEINTERPREOALT[',@Var_SQLState,'-' , @Var_SQLMessage,']');
			END;

	IF(IFNULL(Par_FechaDeteccion,Fecha_Vacia)) = Fecha_Vacia THEN
		SET Par_NumErr :=  '001';
		SET Par_ErrMen := CONCAT('La Fecha esta Vacia.');
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Var_ClaveRegistra, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr :=  '002';
		SET Par_ErrMen := CONCAT('La Clave de Registro esta Vacia.');
		LEAVE TerminaStore;
	END IF;

	SET Var_CatMotivPreoID := (SELECT CatMotivPreoID FROM PLDCATMOTIVPREO WHERE CatMotivPreoID=Par_CatMotivPreoID);

	IF(IFNULL(Var_CatMotivPreoID, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr :=  '003';
		SET Par_ErrMen := CONCAT('El Motivo de la Operacion No es Valido.');
		LEAVE TerminaStore;
	END IF;

	SET Var_CatProcedIntID := (SELECT CatProcedIntID FROM PLDCATPROCEDINT WHERE CatProcedIntID=Par_CatProcedIntID);

	IF(IFNULL(Var_CatProcedIntID, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr :=  '004';
		SET Par_ErrMen := CONCAT('El Proceso de la Operacion No es Valido.');
		LEAVE TerminaStore;
	END IF;

	call FOLIOSAPLICAACT('PLDOPEINTERPREO', Var_OpeInterPreoID);

	SET	Tipo_Persona	:= (SELECT P.CategoriaID FROM EMPLEADOS E
								INNER JOIN PUESTOS P ON E.ClavePuestoID = P.ClavePuestoID
							WHERE E.EmpleadoID=Par_ClavePersonaInv);

	SET	Var_SucursalID	:= (SELECT SucursalID FROM EMPLEADOS WHERE EmpleadoID=Par_ClavePersonaInv);
	SET Par_FechaDeteccion:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

	INSERT INTO PLDOPEINTERPREO (
		Fecha,				OpeInterPreoID,		ClaveRegistra,		NombreReg,			CatProcedIntID,
		CatMotivPreoID,		FechaDeteccion,		CategoriaID,		SucursalID,			ClavePersonaInv,
		NomPersonaInv,		CteInvolucrado,		Frecuencia,			DesFrecuencia,		DesOperacion,
		Estatus
	) VALUES (
		Par_FechaDeteccion,	Var_OpeInterPreoID,	Var_ClaveRegistra,	Var_NombreReg,		Par_CatProcedIntID,
		Par_CatMotivPreoID,	Par_FechaDeteccion,	Tipo_Persona,		Var_SucursalID,		Par_ClavePersonaInv,
		Par_NomPersonaInv,	Par_CteInvolucrado,	Par_Frecuencia,		Par_DesFrecuencia,	Par_DesOperacion,
		Estatus_C);
        
	CALL PLDENVALERTASPRO(
	Tipo_IntPreo,	Var_OpeInterPreoID,		Str_No,		Par_NumErr,		Par_ErrMen,
    Entero_Cero,	Entero_Cero,			NOW(),		'127.0.0.1',	'PLDOPEINTERPREOALT',	
    Entero_Cero,	Entero_Cero);


	SET Par_NumErr := 000;
	SET Par_ErrMen := CONCAT('Operacion Agregada Exitosamente:',Var_OpeInterPreoID,'.');

END ManejoErrores;

IF(Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			'opeInterPreoID' AS Control,
			Var_OpeInterPreoID AS Consecutivo;
END IF;

END TerminaStore$$

