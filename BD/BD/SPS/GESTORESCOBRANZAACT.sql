-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GESTORESCOBRANZAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `GESTORESCOBRANZAACT`;DELIMITER $$

CREATE PROCEDURE `GESTORESCOBRANZAACT`(

	Par_GestorID		INT(11),
    Par_FechaSis		DATE,
    Par_UsuLogeadoID	INT(11),
    Par_NumAct			TINYINT UNSIGNED,

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


    DECLARE Var_Control		VARCHAR(50);
    DECLARE Var_Consecutivo	VARCHAR(20);
    DECLARE Var_NumCredAsig	INT(11);


    DECLARE Fecha_Vacia		DATE;
    DECLARE Entero_Cero		INT(11);
    DECLARE Cadena_Vacia	CHAR(1);
    DECLARE Act_Baja		INT(11);
    DECLARE Act_Activa		INT(11);
    DECLARE Estatus_Baja	CHAR(1);
    DECLARE Estatus_Activo	CHAR(1);
    DECLARE Salida_SI		CHAR(1);


	SET	Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
    SET Cadena_Vacia		:= '';
    SET Act_Baja			:= 3;
    SET Act_Activa			:= 4;
    SET Estatus_Baja		:= 'B';
    SET Estatus_Activo		:= 'A';
	SET Aud_FechaActual = now();
    SET Salida_SI			:= 'S';

	ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
		concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-GESTORESCOBRANZAMOD');
		SET Var_Control = 'sqlException' ;
	END;

    SET Aud_FechaActual = now();


    IF(Par_NumAct = Act_Baja) THEN

    SET Var_NumCredAsig := (SELECT COUNT(GestorID) FROM COBCARTERAASIG WHERE GestorID = Par_GestorID AND EstatusAsig = 'A');

	IF(IFNULL(Var_NumCredAsig,Entero_Cero) > Entero_Cero) THEN
		SET Par_NumErr = 1;
		SET Par_ErrMen = 'No se realizo la Eliminacion, el Gestor Tiene Creditos Asignados';
        SET Var_Consecutivo = Par_GestorID;
		SET Var_Control = 'gestorID' ;
		LEAVE ManejoErrores;
    END IF;

		UPDATE GESTORESCOBRANZA SET
			`Estatus`			=	Estatus_Baja,
            `FechaBaja`			=	Par_FechaSis,
			`UsuarioBajaID`		=	Par_UsuLogeadoID,


			`EmpresaID`			=	Par_EmpresaID,
			`Usuario`			=	Aud_Usuario,
			`FechaActual`		=	Aud_FechaActual,
			`DireccionIP`		=	Aud_DireccionIP,
			`ProgramaID`		=	Aud_ProgramaID,
			`Sucursal`			=	Aud_Sucursal,
			`NumTransaccion`	=	Aud_NumTransaccion
		WHERE GestorID = Par_GestorID;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= CONCAT('Gestor de Cobranza Eliminado Exitosamente: ', CAST(Par_GestorID AS CHAR) );
		SET Var_Control	:= 'gestorID';
		SET Var_Consecutivo:= Par_GestorID;

    END IF;

    IF(Par_NumAct = Act_Activa) THEN

		UPDATE GESTORESCOBRANZA SET
			`Estatus`			=	Estatus_Activo,
            `FechaActivacion`	=	Par_FechaSis,
			`UsuarioActivaID`	=	Par_UsuLogeadoID,


			`EmpresaID`			=	Par_EmpresaID,
			`Usuario`			=	Aud_Usuario,
			`FechaActual`		=	Aud_FechaActual,
			`DireccionIP`		=	Aud_DireccionIP,
			`ProgramaID`		=	Aud_ProgramaID,
			`Sucursal`			=	Aud_Sucursal,
			`NumTransaccion`	=	Aud_NumTransaccion
		WHERE GestorID = Par_GestorID;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= CONCAT('Gestor de Cobranza Activado Exitosamente: ', CAST(Par_GestorID AS CHAR) );
		SET Var_Control	:= 'gestorID';
		SET Var_Consecutivo:= Par_GestorID;

    END IF;

    END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr	AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo	AS consecutivo;
	END IF;



END TerminaStore$$