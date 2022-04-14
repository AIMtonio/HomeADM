-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDESCEROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDESCEROALT`;DELIMITER $$

CREATE PROCEDURE `SOLICITUDESCEROALT`(
    /*SP PARA ALMACENAR LOS CREDITOS QUE NO TIENEN SOLICITUD DE CREDITO*/
    Par_CreditoID  			BIGINT(12), -- Numero de Credito
	Par_FechaRegistro		DATE,		-- Fecha de Alta del Credito
    Par_UsuarioAut			INT(11),    -- Usuario que da de Alta la Solicitud de Credito
	Par_Salida          	CHAR(1),

    INOUT Par_NumErr    	INT(11),
    INOUT Par_ErrMen    	VARCHAR(400),
    /* Parametros de Auditoria */
	Par_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal       	 	INT(11),
    Aud_NumTransaccion  	BIGINT(20)
    		)
TerminaStore: BEGIN

    # Declaracion de variables
	DECLARE Var_SolicitudCeroID INT(11);
    DECLARE VarControl 			VARCHAR(15);
	DECLARE Var_FechaInicial	DATETIME;

    # Declaracion de constantes
    DECLARE Entero_Cero         INT(11);
    DECLARE Decimal_Cero        DECIMAL(14,2);
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Fecha_Vacia         DATE;

	DECLARE SalidaSI			CHAR(1);
    DECLARE SalidaNO			CHAR(1);

    # Asignacion de Constantes
    SET Entero_Cero             := 0;               # Constante entero cero
    SET Decimal_Cero            := 0.0;             # Constante DECIMAL cero
    SET Fecha_Vacia             := '1900-01-01';    # Constante fecha vacia
    SET Cadena_Vacia            := '';              # Constante cadena vacia

    SET SalidaSI            	:= 'S';
	SET SalidaNO            	:= 'N';



    SET Var_SolicitudCeroID:= (SELECT IFNULL(MAX(SolicitudCeroID),Entero_Cero) + 1
                            FROM SOLICITUDESCERO);

    SET	Par_CreditoID		:= IFNULL(Par_CreditoID, Entero_Cero);
    SET	Par_FechaRegistro 	:= IFNULL(Par_FechaRegistro, Fecha_Vacia);
    SET	Var_SolicitudCeroID	:= IFNULL(Var_SolicitudCeroID, Entero_Cero);
    SET	Par_UsuarioAut 		:= IFNULL(Par_UsuarioAut, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
					' esto le ocasiona. Ref: SP-SOLICITUDESCEROALT');
				SET VarControl = 'SQLEXCEPTION' ;
			END;

			-- Se inserta el registro

			 INSERT INTO SOLICITUDESCERO	(
				SolicitudCeroID,	CreditoID,		FechaRegistro,	UsuarioID,	EmpresaID,
                Usuario,			FechaActual,	DireccionIP,	ProgramaID,	Sucursal,
                NumTransaccion)
			VALUES (
				Var_SolicitudCeroID,	Par_CreditoID,		Par_FechaRegistro,		Par_UsuarioAut,
                Par_EmpresaID,      Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
                Aud_ProgramaID,		Aud_Sucursal,   Aud_NumTransaccion  );


		SET Par_NumErr  := 000;
		SET Par_ErrMen  := CONCAT('Credito Agregado Exitosamente');
		SET VarControl	:= '';

	END ManejoErrores;
	IF (Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		VarControl AS control,
		Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$