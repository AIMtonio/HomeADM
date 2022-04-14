-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GESTORESCOBRANZAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `GESTORESCOBRANZAALT`;DELIMITER $$

CREATE PROCEDURE `GESTORESCOBRANZAALT`(

	Par_TipoGestor		CHAR(1),
	Par_UsuarioID		INT(11),
	Par_Nombre			VARCHAR(45),
	Par_ApePaterno		VARCHAR(45),
	Par_ApeMaterno		VARCHAR(45),

	Par_TelParticular	VARCHAR(20),
	Par_TelCelular		VARCHAR(20),
	Par_EstadoID		INT(11),
	Par_MunicipioID		INT(11),
	Par_LocalidadID		INT(11),

	Par_ColoniaID		INT(11),
	Par_Calle			VARCHAR(50),
	Par_NumeroCasa		CHAR(10),
	Par_NumInterior		CHAR(10),
	Par_Piso			VARCHAR(50),

	Par_PrimEntreCalle	VARCHAR(50),
	Par_SegEntreCalle	VARCHAR(50),
	Par_CP				CHAR(5),
	Par_PorcenComision	DECIMAL(12,2),
	Par_TipoAsigCobraID	INT(11),

    Par_UsuarioRegID	INT(11),
    Par_FechaRegistro	DATE,

    Par_Salida			CHAR(1),
    inout Par_NumErr	INT(11),
    inout Par_ErrMen	VARCHAR(150),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN


    DECLARE Var_GestorID	INT(11);
    DECLARE Var_Control		VARCHAR(50);
    DECLARE Var_Consecutivo	VARCHAR(20);
    DECLARE Var_NombreComp	VARCHAR(200);
    DECLARE Var_UsuAsigID	INT(11);



    DECLARE Fecha_Vacia		DATE;
    DECLARE Entero_Cero		INT(11);
    DECLARE Cadena_Vacia	CHAR(1);
    DECLARE Gestor_Interno	CHAR(1);
    DECLARE Gestor_Externo	CHAR(1);
    DECLARE Entero_Cincuenta INT(11);
    DECLARE Estatus_Activo	CHAR(1);
    DECLARE Salida_SI		CHAR(1);


	SET	Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
    SET Cadena_Vacia		:= '';
    SET Gestor_Interno		:= 'I';
	SET Gestor_Externo		:= 'E';
	SET Entero_Cincuenta	:= 50;
	SET Estatus_Activo		:= 'A';
    SET Salida_SI			:= 'S';

	ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
		concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-GESTORESCOBRANZAALT');
		SET Var_Control = 'sqlException' ;
	END;

	IF(IFNULL(Par_TipoGestor, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'El Tipo de Gestor esta Vacio';
		SET Var_Control	:= 'tipoGestor';
		LEAVE ManejoErrores;
	END IF;

    IF(Par_TipoGestor = Gestor_Interno) then
		IF(IFNULL(Par_UsuarioID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'El Usuario esta Vacio';
			SET Var_Control	:= 'usuarioID';
			LEAVE ManejoErrores;
		ELSE
			IF EXISTS (SELECT UsuarioID FROM GESTORESCOBRANZA WHERE UsuarioID = Par_UsuarioID) THEN
				SET Par_NumErr := 3;
				SET Par_ErrMen := CONCAT('El Usuario ',Par_UsuarioID,' ya se Encuentra Registrado como Gestor');
				SET Var_Control	:= 'usuarioID';
				LEAVE ManejoErrores;
            END IF;
		END IF;
    END IF;

	IF(Par_TipoGestor = Gestor_Externo) then
		IF(IFNULL(Par_Nombre, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'El Nombre esta Vacio';
			SET Var_Control	:= 'nombre';
			LEAVE ManejoErrores;
		END IF;
	END IF;

    IF(Par_PorcenComision < Entero_Cero) THEN
		SET Par_NumErr := 5;
		SET Par_ErrMen := 'El % Comision debe ser Mayor o Igual a 0';
		SET Var_Control	:= 'porcentajeComision';
		LEAVE ManejoErrores;
	END IF;

    IF(Par_PorcenComision > Entero_Cincuenta) THEN
		SET Par_NumErr := 6;
		SET Par_ErrMen := 'El % Comision debe ser Menor o Igual a 50';
		SET Var_Control	:= 'porcentajeComision';
		LEAVE ManejoErrores;
	END IF;


	CALL FOLIOSAPLICAACT('GESTORESCOBRANZA', Var_GestorID);
       SET Aud_FechaActual = now();

       SET Var_NombreComp := CONCAT(Par_Nombre,' ',Par_ApePaterno,' ',Par_ApeMaterno);

	INSERT INTO `GESTORESCOBRANZA`(
		`GestorID`, 			`TipoGestor`, 			`UsuarioID`, 			`Nombre`, 			`ApellidoPaterno`,
        `ApellidoMaterno`, 		`TelefonoParticular`, 	`TelefonoCelular`, 		`EstadoID`, 		`MunicipioID`,
        `LocalidadID`, 			`ColoniaID`, 			`Calle`, 				`NumeroCasa`, 		`NumInterior`,
        `Piso`, 				`PrimeraEntreCalle`, 	`SegundaEntreCalle`, 	`CP`, 				`PorcentajeComision`,
        `TipoAsigCobranzaID`, 	`Estatus`, 				`FechaRegistro`, 		`FechaActivacion`, 	`FechaBaja`,
        `UsuarioRegistroID`, 	`UsuarioActivaID`, 		`NombreCompleto`,
        `EmpresaID`, 			`Usuario`,				`FechaActual`,			`DireccionIP`, 		`ProgramaID`,
        `Sucursal`, 			`NumTransaccion`)
	VALUES(
		Var_GestorID,			Par_TipoGestor,			Par_UsuarioID,			Par_Nombre,			Par_ApePaterno,
		Par_ApeMaterno,			Par_TelParticular,		Par_TelCelular,			Par_EstadoID,		Par_MunicipioID,
		Par_LocalidadID,		Par_ColoniaID,			Par_Calle,				Par_NumeroCasa,		Par_NumInterior,
		Par_Piso,				Par_PrimEntreCalle,		Par_SegEntreCalle,		Par_CP,				Par_PorcenComision,
		Par_TipoAsigCobraID,	Estatus_Activo,			Par_FechaRegistro,		Par_FechaRegistro,	Fecha_Vacia,
        Par_UsuarioRegID,		Par_UsuarioRegID,		Var_NombreComp,
		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
        Aud_Sucursal,			Aud_NumTransaccion
        );

	SET Par_NumErr	:= 0;
	SET Par_ErrMen	:= CONCAT('Gestor de Cobranza Agregado Exitosamente: ', CAST(Var_GestorID AS CHAR) );
	SET Var_Control	:= 'gestorID';
	SET Var_Consecutivo:= Var_GestorID;

    END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr	AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo	AS Consecutivo;
	END IF;


END TerminaStore$$