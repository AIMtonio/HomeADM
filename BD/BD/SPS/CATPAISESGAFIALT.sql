-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATPAISESGAFIALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATPAISESGAFIALT`;DELIMITER $$

CREATE PROCEDURE `CATPAISESGAFIALT`(
/* SP DE ALTA EN EL CATALOGO DE PAISES DE LA GAFI */
	Par_PaisID					INT(11),		-- Numero de Pais, corresponde al ID de PAISES
	Par_NombrePais				VARCHAR(150),	-- Nombre del Pais
	Par_TipoPais				CHAR(45),		-- N.- Paises No Cooperantes M.- Paises en Mejora
	Par_Salida           		CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     		INT,			-- Numero de Error

	INOUT Par_ErrMen     		VARCHAR(400),	-- Mensaje de Error
    /* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),

	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control     CHAR(15);
DECLARE	Var_PaisID		INT(11);
DECLARE	Var_TipoPais	CHAR(1);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	SalidaSI        CHAR(1);
DECLARE	SalidaNO        CHAR(1);
DECLARE	TipoNoCoop      CHAR(1);
DECLARE	TipoMejora      CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI        	:= 'S';				-- Salida Si
SET	SalidaNO        	:= 'N'; 			-- Salida No
SET	TipoNoCoop        	:= 'N';				-- Tipo de Pais No Cooperante
SET	TipoMejora        	:= 'M'; 			-- Tipo de Pais en Mejora
SET Aud_FechaActual 	:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CATPAISESGAFIALT');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(IFNULL(Par_PaisID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'El Pais esta Vacio.';
		SET Var_Control:= 'paisID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(NOT EXISTS(SELECT Nombre FROM PAISES WHERE PaisID=IFNULL(Par_PaisID, Entero_Cero))) THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'El Pais No Existe.';
		SET Var_Control:= 'paisID' ;
		LEAVE ManejoErrores;
    END IF;

	IF(NOT EXISTS(SELECT Nombre FROM PAISES WHERE PaisID=IFNULL(Par_PaisID, Entero_Cero))) THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'El Pais No Existe.';
		SET Var_Control:= 'paisID' ;
		LEAVE ManejoErrores;
    END IF;

	IF(EXISTS(SELECT Nombre FROM CATPAISESGAFI WHERE PaisID=IFNULL(Par_PaisID, Entero_Cero))) THEN
		SET Var_TipoPais 	:= (SELECT TipoPais FROM CATPAISESGAFI WHERE PaisID=IFNULL(Par_PaisID, Entero_Cero));
		SET Var_TipoPais 	:= IFNULL(Var_TipoPais,Cadena_Vacia);
		SET Par_NumErr 		:= 4;
		SET Par_ErrMen 		:= CONCAT('El Pais ',IFNULL(Par_NombrePais, Cadena_Vacia),
							' ya se Encuenta Registrado en el Catalogo ',IF(Var_TipoPais=TipoMejora,'Paises en Mejora.','Paises No Cooperantes.'));
		SET Var_Control		:= 'paisID' ;
		LEAVE ManejoErrores;
    END IF;

	SET Par_NombrePais := (SELECT Nombre FROM PAISES WHERE PaisID=IFNULL(Par_PaisID, Entero_Cero));
	SET Par_NombrePais := IFNULL(Par_NombrePais, Cadena_Vacia);

	IF(IFNULL(Par_TipoPais, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 5;
		SET Par_ErrMen := 'El Tipo de Pais esta Vacio.';
		SET Var_Control:= 'tipoPais' ;
		LEAVE ManejoErrores;
	END IF;

	INSERT INTO CATPAISESGAFI(
		PaisID,				Nombre,				TipoPais,			EmpresaID,			Usuario,
        FechaActual,		DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
	VALUES(
		Par_PaisID,			Par_NombrePais,		Par_TipoPais,		Par_EmpresaID,		Aud_Usuario,
        Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Catalogo Grabado Exitosamente.';
	SET Var_Control:= 'paisID' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			Par_PaisID AS Consecutivo;
END IF;

END TerminaStore$$