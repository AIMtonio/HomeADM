-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBAMORTICREDITOWSVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBAMORTICREDITOWSVAL`;DELIMITER $$

CREATE PROCEDURE `CRCBAMORTICREDITOWSVAL`(
	/*SP para listar las amortizaciones de credito para WS Crediclub*/
	Par_CreditoID			BIGINT(12),			-- Identificador del credito
	/* Parametros de Auditoria */
    Par_Salida				CHAR(1),				#Salida S:Si No:No
	INOUT Par_NumErr		INT(11),				# Numero de error
	INOUT Par_ErrMen		VARCHAR(400),			# Mensaje de error

	Par_EmpresaID			INT(11),			-- Auditoria
	Aud_Usuario				INT(11),			-- Auditoria
	Aud_FechaActual			DATETIME,			-- Auditoria

	Aud_DireccionIP			VARCHAR(15),		-- Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Auditoria
	Aud_Sucursal			INT(11),			-- Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Auditoria
)
TerminaStore: BEGIN

    -- variables
    DECLARE Var_Control		VARCHAR(50);		-- Nombre del campo
    DECLARE Var_EstatusCre	CHAR(1);			-- Estatus del credito
    DECLARE Var_EstatusCli	CHAR(1);			-- Estatus del cliente
    DECLARE Var_ClienteID	INT(11);			-- Idetificador del cliente
	DECLARE Var_EjecutaCierre	CHAR(1);			-- indica si se esta realizando el cierre de dia

    -- constantes
    DECLARE Entero_Cero			INT;
    DECLARE Cadena_Vacia		VARCHAR(2);
    DECLARE Est_CreInactivo		CHAR(1);
    DECLARE Est_CliCancelado	CHAR(1);
    DECLARE Salida_SI 			CHAR(1);
    DECLARE ValorCierre			VARCHAR(30);


    SET Entero_Cero  		:= 0;		-- entero vacio
    SET Cadena_Vacia 		:= '';		-- cadena vacia
    SET Est_CreInactivo		:= 'I';		-- Credito inactivo
    SET Est_CliCancelado 	:= 'I'; 	-- Cliente cancelado
    SET Salida_SI 			:= 'S'; 	-- Indica si se realiza la salida de datos
 	SET ValorCierre			:= 'EjecucionCierreDia'; -- INDICA SI SE REALIZA EL CIERRE DE DIA.


    ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRCBAMORTICREDITOWSVAL');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		SET Var_EjecutaCierre := (SELECT  ValorParametro  FROM PARAMGENERALES WHERE LlaveParametro = ValorCierre);

		-- Validamos que no se este ejecutando el cierre de dia
		IF(IFNULL(Var_EjecutaCierre,Cadena_Vacia)=Salida_SI)THEN
			SET Par_NumErr  := 800;
			SET Par_ErrMen  := CONCAT('El Cierre de Dia Esta en Ejecucion, Espere un Momento Por favor.');
			LEAVE ManejoErrores;
		END IF;

        IF IFNULL(Par_CreditoID,Entero_Cero)  = Entero_Cero THEN
			SET Par_NumErr 		:= 4;
			SET Par_ErrMen 		:= 'El credito esta vacio';
			SET Var_Control 	:= 'creditoID' ;
			LEAVE ManejoErrores;
        END IF;

        IF NOT EXISTS ( SELECT CreditoID
							FROM CREDITOS
							WHERE CreditoID = Par_CreditoID) THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'El credito no existe';
			SET Var_Control 	:= 'creditoID' ;
			LEAVE ManejoErrores;
        END IF;

        SELECT Estatus
			INTO Var_EstatusCre
            FROM CREDITOS
            WHERE CreditoID = Par_CreditoID;

        IF IFNULL(Var_EstatusCre,Est_CreInactivo) = Est_CreInactivo THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'El credito se encuentra Inactivo';
			SET Var_Control 	:= 'clienteID' ;
			LEAVE ManejoErrores;
        END IF;

		SELECT  ClienteID
			INTO Var_ClienteID
			FROM CREDITOS
			WHERE CreditoID = Par_CreditoID;

        SELECT Estatus
			INTO Var_EstatusCli
            FROM CLIENTES
            WHERE ClienteID = Var_ClienteID;

		IF IFNULL(Var_EstatusCli,Est_CliCancelado) = Est_CliCancelado THEN
			SET Par_NumErr 		:= 3;
			SET Par_ErrMen 		:= 'El cliente se encuentra Cancelado';
			SET Var_Control 	:= 'clienteID' ;
			LEAVE ManejoErrores;
        END IF;

        SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= 'Consulta realizada Exitosamente';
		SET Var_Control 	:= 'clienteID' ;

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS control;
	END IF;

END TerminaStore$$