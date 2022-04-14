-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EMISIONNOTICOBALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EMISIONNOTICOBALT`;DELIMITER $$

CREATE PROCEDURE `EMISIONNOTICOBALT`(

    Par_CreditoID		BIGINT(12),
    Par_FechaEmision 	DATE,
    Par_UsuarioID 		INT(11),
    Par_ClaveUsuario	VARCHAR(45),
    Par_SucursalUsuID	INT(11),

	Par_FormatoID		INT(11),
    Par_FechaCita 		DATE,
    Par_HoraCita		VARCHAR(10),

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
    DECLARE Var_Reporte		VARCHAR(50);


    DECLARE Fecha_Vacia		DATE;
    DECLARE Entero_Cero		INT(11);
    DECLARE Entero_Uno		INT(11);
    DECLARE Cadena_Vacia	CHAR(1);
    DECLARE Salida_SI		CHAR(1);


	SET	Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
    SET Cadena_Vacia		:= '';
    SET Salida_SI			:= 'S';

	ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
		concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-EMISIONNOTICOBALT');
		SET Var_Control = 'sqlException' ;
	END;

        IF EXISTS (SELECT CreditoID FROM EMISIONNOTICOB WHERE CreditoID = Par_CreditoID AND FechaEmision = Par_FechaEmision)THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := CONCAT('Al Credito ',Par_CreditoID,' ya se Realizo una Emision de Notificacion de Cobranza');
			SET Var_Control	:= '';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS (SELECT FormatoID FROM FORMATONOTIFICACOB WHERE FormatoID = Par_FormatoID )THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := CONCAT('El Formato de Notificacion para el Credito: ',Par_CreditoID,' no Existe');
			SET Var_Control	:= '';
			LEAVE ManejoErrores;
		END IF;

        SET Var_Reporte := (SELECT Reporte FROM FORMATONOTIFICACOB WHERE FormatoID = Par_FormatoID);
        IF (IFNULL(Var_Reporte,Cadena_Vacia ) = Cadena_Vacia)THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := CONCAT('EL Nombre del Reporte para el Credito: ',Par_CreditoID,' esta Vacio');
			SET Var_Control	:= '';
			LEAVE ManejoErrores;
        END IF;

        SET Aud_FechaActual := now();

        INSERT INTO EMISIONNOTICOB
		(	`CreditoID`, 		`FechaEmision`, 	`UsuarioID`, 		`ClaveUsuario`, 	`SucursalUsuID`,
			`FormatoID`, 		`FechaCita`, 		`HoraCita`, 		`EmpresaID`, 		`Usuario`,
            `FechaActual`,		`DireccionIP`, 		`ProgramaID`, 		`Sucursal`, 		`NumTransaccion`
		)VALUES(
			Par_CreditoID,		Par_FechaEmision,	Par_UsuarioID,		Par_ClaveUsuario,	Par_SucursalUsuID,
            Par_FormatoID,		Par_FechaCita,		Par_HoraCita,		Par_EmpresaID,		Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
		);

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= CONCAT('Emision de Notificacion de Cobranza Realizado Exitosamente: ', CAST(Par_CreditoID AS CHAR) );
		SET Var_Control	:= 'sucursalID';
		SET Var_Consecutivo:= Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr	AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo	AS Consecutivo;
	END IF;


END TerminaStore$$