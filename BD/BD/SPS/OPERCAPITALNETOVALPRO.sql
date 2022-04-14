-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPERCAPITALNETOVALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPERCAPITALNETOVALPRO`;
DELIMITER $$

CREATE PROCEDURE `OPERCAPITALNETOVALPRO`(
# =========================================================================
# -------PROCESO ENCARGADO DE EVALUAR EL CAPITAL NETO DE LA ENTIDAD--------
# =========================================================================
    Par_InstrumentoID		BIGINT(12),		-- Numero de instrumento a validar
	Par_MontoMov			DECIMAL(18,2),	-- Monto
	Par_Origen				CHAR(1),		-- Origen V.-Ventanilla, I.-Inversiones, C.-CEDES, S.-Solicitud Credito
	Par_PantallaOrigen		VARCHAR(3),		-- PANTALLA AS.-Autorizacion Solicitud Cred. AI.-Autorizacion Inversion AC.-Autorizacion CEDE AC.-ABONO A CUENTA

    Par_Salida				CHAR(1),		-- Indica Salida
	INOUT Par_NumErr		INT(11),		-- Inout NumErr
    INOUT Par_ErrMen		VARCHAR(400),	-- Inout ErrMen
	Par_EmpresaID			INT(11),        -- Parametro de Auditoria Par_Empresa.
	Aud_Usuario				INT(11),		-- Parametro de Auditoria Aud_Usuario.

    Aud_FechaActual			DATETIME,		-- Parametro de Auditoria Aud_FechaActual.
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria Aud_DireccionIP.
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria Aud_ProgramaID.
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria Aud_Sucursal.
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria Aud_Numtransaccion.
)
TerminaStored:BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_Control				VARCHAR(100);	-- CONTROL
DECLARE Var_ValidaCapitalConta  CHAR(1);		-- VALIDA CAPITAL CONTABLE S.-SI, N.-NO
DECLARE Var_PorMaximoDeposito   VARCHAR(10);	-- PORCENTAJE MAXIMO DE DEPOSITOS
DECLARE Var_MontoLimDep			DECIMAL(18,2);	-- MONTO LIMITE DE DEPOSITO
DECLARE Var_CapNeto				DECIMAL(18,2);	-- CAPITAL NETO DE LA CTA
DECLARE Var_OperacionID			INT(11);		-- OPERACION
DECLARE Var_ClienteID			INT(11);		-- CLIENTE
DECLARE Var_FechaSistema		DATE;			-- FECHA DEL SISTEMA
DECLARE Var_ProductoID			INT(11);		-- PRODUCTO
DECLARE Var_Mensaje				VARCHAR(400);	-- MENSAJE
DECLARE Var_Instrumento			BIGINT(12);		-- INSTRUMENTO
DECLARE Var_Origen				CHAR(1);		-- ORIGEN
DECLARE Var_PantallaOrigen		VARCHAR(3);		-- ORIGEN DE PANTALLA
DECLARE Var_Monto				DECIMAL(18,2);	-- MONTO
DECLARE Var_Porcentaje			VARCHAR(10);	-- PORCENTAJE
DECLARE Var_SucursalID			INT(11);		-- SUCURSAL DEL CLIENTE

-- DECLARACION DEC CONSTANTES
DECLARE Entero_Cero				INT(1);
DECLARE SalidaSI				CHAR(1);
DECLARE Cadena_Vacia			CHAR(1);


-- ASIGNACION DE CONSTANTES
SET Entero_Cero                  :=	0;		    -- Constante Entero Cero
SET SalidaSI                    :=	'S';	    -- Constante Salida SI
SET Cadena_Vacia                :=	'';		    -- Constante Cadena Vacía
SET Var_OperacionID				:= Entero_Cero;


ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-OPERCAPITALNETOVALPRO');
					SET Var_Control = 'sqlException' ;
		END;
    SET Par_ErrMen	:='';

	SELECT   ValidaCapitalConta, 		    PorMaximoDeposito,          SaldoCapContable,	FechaSistema
            INTO Var_ValidaCapitalConta, 	Var_PorMaximoDeposito,      Var_CapNeto,		Var_FechaSistema
    FROM PARAMETROSSIS
    WHERE EmpresaID = Par_EmpresaID;


    SELECT 	 InstrumentoID, 	OrigenOperacion, 	PantallaOrigen, 		MontoOper, 		Porcentaje
		INTO Var_Instrumento,	Var_Origen, 		Var_PantallaOrigen, 	Var_Monto, 		Var_Porcentaje
	FROM OPERCAPITALNETO
	WHERE InstrumentoID = Par_InstrumentoID
	AND OrigenOperacion = Par_Origen
	AND PantallaOrigen  = Par_PantallaOrigen
    LIMIT 1;

	SET Var_Instrumento := IFNULL(Var_Instrumento, Entero_Cero);
	SET Var_Origen := IFNULL(Var_Origen, Cadena_Vacia);
	SET Var_PantallaOrigen := IFNULL(Var_PantallaOrigen, Cadena_Vacia);
	SET Var_Monto := IFNULL(Var_Monto, Entero_Cero);
	SET Var_Porcentaje := IFNULL(Var_Porcentaje, Entero_Cero);


	CASE Par_Origen
		WHEN 'V' THEN -- VENTANILLA
			SELECT 	cta.ClienteID INTO	Var_ClienteID
				FROM CUENTASAHO cta
					INNER JOIN TIPOSCUENTAS tipo ON cta.TipoCuentaID = tipo.TipoCuentaID
				WHERE cta.CuentaAhoID = Par_InstrumentoID;
			SET Var_Mensaje := 'El monto depositado ';
			SET Var_Control := 'tipoOperacion';
		WHEN 'S' THEN -- SOLICITUD DE CREDITO

			SELECT   ClienteID, 	ProductoCreditoID
				INTO Var_ClienteID,	Var_ProductoID
			FROM SOLICITUDCREDITO
			WHERE SolicitudCreditoID= Par_InstrumentoID;

            SELECT   validaCapConta,			porcMaxCapConta
				INTO Var_ValidaCapitalConta,	Var_PorMaximoDeposito
				FROM PRODUCTOSCREDITO
                WHERE ProducCreditoID=Var_ProductoID;
			SET Var_Mensaje := 'Para continuar con el flujo de credito es necesario realizar la autorizacion en la pantalla <b>Autorizacion Operacion Capital Neto</b>. Debido a que el monto ';
			SET Var_Control := 'solicitudCreditoID';
		WHEN 'I' THEN -- INVERSIONES
			SELECT   ClienteID,		TipoInversionID
				INTO Var_ClienteID,	Var_ProductoID
			FROM INVERSIONES
			WHERE InversionID = Par_InstrumentoID;
			SET Var_Mensaje := 'Para continuar con el flujo de autorizacion de inversion es necesario realizar la autorizacion en la pantalla <b>Autorizacion Operacion Capital Neto</b>. Debido a que el monto ';
			SET Var_Control := 'inversionID';
		WHEN 'C' THEN -- CEDES
			SELECT   ClienteID, 	TipoCedeID,			Monto
				INTO Var_ClienteID,	Var_ProductoID,		Par_MontoMov
			FROM CEDES
			WHERE CedeID = Par_InstrumentoID;
			SET Var_Mensaje := 'Para continuar con el flujo de autorizacion de CEDE es necesario realizar la autorizacion en la pantalla <b>Autorizacion Operacion Capital Neto</b>. Debido a que el monto ';
			SET Var_Control := 'cedeID';
	END CASE;


	SET Var_ClienteID := IFNULL(Var_ClienteID, Entero_Cero);
	SET Var_ProductoID := IFNULL(Var_ProductoID, Entero_Cero);
    SET Var_CapNeto := IFNULL(Var_CapNeto, Entero_Cero);
    SET Var_MontoLimDep := (Var_PorMaximoDeposito * Var_CapNeto)/100;

	SELECT SucursalOrigen INTO Var_SucursalID
		FROM CLIENTES
		WHERE ClienteID= Var_ClienteID;

	SET Var_SucursalID := IFNULL(Var_SucursalID, Entero_Cero);

	IF(Var_ValidaCapitalConta = "S" AND (Par_MontoMov>Var_MontoLimDep))THEN

		SET Var_OperacionID 	:= (SELECT IFNULL(MAX(OperacionID),Entero_Cero) + 1 FROM OPERCAPITALNETO);
		SET Par_NumErr :=333;
		SET Par_ErrMen :=CONCAT(Var_Mensaje,' [<b>$',FORMAT(Par_MontoMov, 2),'</b>] no puede representar mas de una vez el capital neto de la entidad.' );


        IF(Var_Instrumento !=Var_OperacionID OR Var_Origen!=Par_Origen OR Var_PantallaOrigen!=Par_PantallaOrigen
			OR Var_Monto!=Par_MontoMov OR Var_Porcentaje!=Var_PorMaximoDeposito)THEN

            INSERT INTO OPERCAPITALNETO
						(OperacionID,			ClienteID,			FechaOperacion,			ProductoID,				CapitalNeto,
						 Porcentaje,			MontoOper,			EstatusOper,			Comentario,				OrigenOperacion,
						 PantallaOrigen,		InstrumentoID,		Mensaje,				SucursalCliID,
						 EmpresaID,				Usuario,			FechaActual,			DireccionIP,			ProgramaID,
						 Sucursal,				NumTransaccion
						)
				VALUES(Var_OperacionID,			Var_ClienteID,		Var_FechaSistema,		Var_ProductoID,			Var_CapNeto,
					   Var_PorMaximoDeposito,	Par_MontoMov,		"I",					Cadena_Vacia,			Par_Origen,
					   Par_PantallaOrigen,		Par_InstrumentoID,	Par_ErrMen,				Var_SucursalID,
					   Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
					   Aud_Sucursal,			Aud_NumTransaccion);
		END IF;


		LEAVE ManejoErrores;
	END IF;



	SET Par_NumErr	:=	0;
	SET Par_ErrMen	:=	'Validacion Exitosa.';



END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_InstrumentoID AS Consecutivo;
END IF;


END TerminaStored$$