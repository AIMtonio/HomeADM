-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOCREDITOWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOCREDITOWSPRO`;
DELIMITER $$


CREATE PROCEDURE `PAGOCREDITOWSPRO`(
/* SP DE PROCESO PARA EL PAGO DE CREDITO VIA WS ENTURA, 3 REYES, YANGA*/
	Par_ClienteID			BIGINT,
	Par_CreditoID			BIGINT,
	Par_Monto				DECIMAL(14,2),
	Par_ClaveUsuario		VARCHAR(100),
	Par_Contrasenia			VARCHAR(200),
    Par_NumTra              TINYINT UNSIGNED,

	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
		)

TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE	Var_NumErr			INT;
DECLARE Var_ErrMen			VARCHAR(400);
DECLARE Var_CuentaAhoID		BIGINT;
DECLARE Var_StrCueAhoID		VARCHAR(30);
DECLARE Var_MonedaID		INT;
DECLARE Var_Poliza			BIGINT;
DECLARE Var_Consecutivo		BIGINT;
DECLARE Var_FechaSistema	DATE;
DECLARE Var_SucCliente		INT;
DECLARE	Var_RefereMov		VARCHAR(35);
DECLARE Var_UsuarioID		INT(11);
DECLARE Var_SucursalID		INT(11);
DECLARE Var_CajaID			INT(11);
DECLARE Var_RolFR			INT(11);
DECLARE Var_EstatusUsuario	CHAR(1);
DECLARE Var_MontoPagado		DECIMAL(14,2);
DECLARE Var_TotDeuda		DECIMAL(14,2);

DECLARE Var_PagCapita		DECIMAL(14,2);
DECLARE Var_PagIntOrd		DECIMAL(14,2);
DECLARE Var_PagIntMora		DECIMAL(14,2);
DECLARE Var_PagIVAIntOrd	DECIMAL(14,2);
DECLARE Var_PagIVAIntMora	DECIMAL(14,2);
DECLARE Var_PagIVATot		DECIMAL(14,2);
DECLARE Var_IVASucurs		DECIMAL(14,4);
DECLARE Var_Promotor        INT(11);
DECLARE Var_EstatusCaja		CHAR(1);


-- Declaracion de Constantes
DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero     	INT;
DECLARE Decimal_Cero    	DECIMAL(12, 2);
DECLARE Decimal_Cien    	DECIMAL(12, 2);
DECLARE NO_EsPrePago		CHAR(1);
DECLARE	NO_EsFiniquito		CHAR(1);
DECLARE Par_SalidaNO    	CHAR(1);
DECLARE AltaPoliza_SI   	CHAR(1);
DECLARE AltaPoliza_NO   	CHAR(1);
DECLARE	Nat_Abono			CHAR(1);
DECLARE	Tip_MovAhoID		CHAR(4);
DECLARE	Tip_ConceptoCon		INT;
DECLARE Con_AhoCapital  	INT;
DECLARE TipoOperacion		INT(1);
DECLARE NatMovi				INT(1);
DECLARE DenominacionID 		INT(4);
DECLARE Est_Activo			CHAR(1);
DECLARE	Aho_DescriMov		VARCHAR(100);
DECLARE	Tran_GrupoNoSoLiWS	INT;
DECLARE	Tran_PromotorWS	    INT;
DECLARE Var_Es_Valido       VARCHAR(10);
DECLARE	ModoPagoEfec 		CHAR(1);
DECLARE Con_Origen			CHAR(1);
DECLARE RespaldaCredSI		CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia    		:= '';              -- String Vacio
SET Fecha_Vacia     		:= '1900-01-01';    -- Fecha Vacia
SET Entero_Cero     		:= 0;               -- Entero en Cero
SET Decimal_Cero    		:= 0.00;            -- DECIMAL Cero
SET Decimal_Cien    		:= 100.00;          -- DECIMAL en Cien
SET NO_EsPrePago			:= 'N';				-- No es Prepago
SET NO_EsFiniquito			:= 'N';				-- No es Finiquito
SET Par_SalidaNO    		:= 'N';             -- Ejecutar Store sin Regreso o Mensaje de Salida
SET AltaPoliza_SI   		:= 'S';             -- Alta de la Poliza Contable: SI
SET AltaPoliza_NO   		:= 'N';             -- Alta de la Poliza Contable: NO
SET Nat_Abono       		:= 'A';             -- Naturaleza de Abono
SET Tip_MovAhoID			:= '10';			-- Tipo de MovimeINTO de Ahorro: Deposito de Efectivo
SET Tip_ConceptoCon			:=  30;				-- Tipo de Concepto Contable: Pago de Credito en Caja
SET Con_AhoCapital  		:= 	1;               -- Concepto Contable de Ahorro: Pasivo
SET TipoOperacion			:= 	8;				-- ENTRADA EFECTIVO POR PAGO DE CREDITO
SET NatMovi					:= 	1;				-- Naturaleza del Movimiento: Entrada
SET DenominacionID			:= 	7;				-- Denominacion: 1-Peso
SET Est_Activo				:= 'A';				-- Estatus de Activo
SET RespaldaCredSI			:= 'S';

SET Tran_GrupoNoSoLiWS		:= 	1;
SET Tran_PromotorWS	    	:= 	2;

SET Aho_DescriMov			:= 'DEPOSITO PAGO DE CREDITO';
SET ModoPagoEfec            := 'E';              -- Modo de Pago: Efectivo
SET Con_Origen				:= 'W';		-- Constante Origen donde se llama el SP (S= safy, W=WS)

ManejoErrores: BEGIN

-- Inicializaciones --
SET Var_NumErr	:= Entero_Cero;
SET Var_ErrMen	:= Cadena_Vacia;
SET Var_Poliza	:= Entero_Cero;
SET Var_Consecutivo	:= Entero_Cero;
SET Var_TotDeuda := Entero_Cero;
SET Var_PagCapita := Entero_Cero;
SET Var_PagIntOrd := Entero_Cero;
SET Var_PagIntMora := Entero_Cero;
SET Var_PagIVAIntOrd := Entero_Cero;
SET Var_PagIVAIntMora := Entero_Cero;

SELECT	UsuarioID, 		 '127.0.0.1' ,			1/*EmpresaID*/ ,		SucursalUsuario
INTO	Aud_Usuario,	Aud_DireccionIP,	Par_EmpresaID,	Aud_Sucursal
	FROM USUARIOS
	WHERE	Clave 		= Par_ClaveUsuario
		AND Contrasenia = Par_Contrasenia
		AND Estatus		= Est_Activo;

SET Aud_FechaActual	:= NOW();


IF(IFNULL(Par_ClienteID,Entero_Cero))= Entero_Cero THEN
				SET   Var_NumErr := 2;
				SET   Var_ErrMen := 'El numero de cliente esta vacio.';
     LEAVE ManejoErrores;
     END IF;

 IF(IFNULL(Par_CreditoID,Entero_Cero))= Entero_Cero THEN
		SET   Var_NumErr := 3;
		SET   Var_ErrMen := 'El numero de cuenta esta vacio.';
    LEAVE ManejoErrores;
     END IF;

 IF(IFNULL(Par_Monto,Decimal_Cero))= Decimal_Cero THEN
		SET   Var_NumErr := 4;
		SET   Var_ErrMen := 'No se especifica monto.';
    LEAVE ManejoErrores;
     END IF;

IF NOT EXISTS (SELECT Usu.UsuarioID
					FROM USUARIOS Usu,
						 PARAMETROSCAJA Par,
						 CAJASVENTANILLA Caj
					WHERE Usu.Clave = Par_ClaveUsuario
						AND Usu.Contrasenia = Par_Contrasenia
						AND Usu.RolID = Par.EjecutivoFR
						AND Usu.Estatus = Est_Activo
						AND Usu.UsuarioID = Caj.UsuarioID
						AND Caj.Estatus = Est_Activo
						AND Caj.EstatusOpera = Est_Activo)THEN


	SELECT	Caj.CajaID,	Caj.EstatusOpera,	Usu.RolID,	Usu.Estatus
	INTO	Var_CajaID, Var_EstatusCaja,	Var_RolFR,	Var_EstatusUsuario
						FROM USUARIOS Usu,
							 PARAMETROSCAJA Par,
							 CAJASVENTANILLA Caj
						WHERE Usu.Clave			= Par_ClaveUsuario
							AND Usu.Contrasenia = Par_Contrasenia
							AND Usu.UsuarioID	= Caj.UsuarioID;

	SET   Var_CajaID			:= IFNULL(Var_CajaID, 0);
	SET   Var_EstatusCaja		:= IFNULL(Var_EstatusCaja, '');
	SET   Var_RolFR				:= IFNULL(Var_RolFR, 0);
	SET   Var_EstatusUsuario	:= IFNULL(Var_EstatusUsuario, '');

	SET   Var_NumErr := 1;
    SET   Var_ErrMen := CONCAT('Usuario y/o Contrasenia incorrectos.|  Caja: ',Var_CajaID, ' con estatus de operacion: ',Var_EstatusCaja, '  | El Rol del Usuario es: ',Var_RolFR , ' | con estatus: ',Var_EstatusUsuario );

	LEAVE ManejoErrores;
END IF;


/* Si la version de parametros caja es YANGA*/

IF(Par_NumTra = Tran_GrupoNoSoLiWS) THEN

/* Valida que la cuenta, el cliente sean validos  y el cliente pertenezca a un grupo No solidario*/
IF NOT EXISTS (SELECT Cre.CreditoID
				FROM CREDITOS Cre,
					 INTEGRAGRUPONOSOL Gru
				WHERE Cre.ClienteID = Gru.ClienteID
					AND Gru.ClienteID = Par_ClienteID
					AND Cre.CreditoID = Par_CreditoID
				AND (Cre.Estatus = 'V' OR Cre.Estatus = 'B'))THEN
	SET   Var_NumErr := 5;
    SET   Var_ErrMen := 'El cliente o la cuenta no son validos.';
	LEAVE ManejoErrores;
END IF;

END IF;

/* Si la version de parametros caja es 3 REYES*/

  IF(Par_NumTra = Tran_PromotorWS) THEN
		/* Valida que la cuenta, el cliente sean validos*/
		IF NOT EXISTS (SELECT Cre.CreditoID
						FROM CREDITOS Cre
						WHERE Cre.CreditoID = Par_CreditoID
						AND (Cre.Estatus = 'V' OR Cre.Estatus = 'B'))THEN
			SET   Var_NumErr := 5;
			SET   Var_ErrMen := 'El cliente o la cuenta no son validos.';
			LEAVE ManejoErrores;
		END IF;

/* Valida que el Usuario sea el PromotOR de la Cuenta el que realiza el Abono*/
  SET   Var_Promotor := (SELECT PromotorID FROM PROMOTORES Pro
                        INNER JOIN USUARIOS Usu
                        ON Usu.UsuarioID = Pro.UsuarioID
                        WHERE Usu.Clave = Par_ClaveUsuario
                        AND Usu.Contrasenia = Par_Contrasenia);

	         IF NOT EXISTS(SELECT Cli.PromotorActual
				           FROM PROMOTORES Pro
					       INNER JOIN CLIENTES Cli
						   ON Cli.PromotorActual = Pro.PromotorID
						   WHERE PromotorActual = Var_Promotor
						   AND Cli.ClienteID = Par_ClienteID)THEN
					   SET   Var_NumErr := 6;
                       SET   Var_ErrMen := 'El usuario no corresponde al promotor del cliente.';

			           LEAVE ManejoErrores;
			           END IF;
               END IF;

SELECT FechaSistema	INTO Var_FechaSistema
	FROM PARAMETROSSIS;

SELECT Cre.CuentaID, Cre.MonedaID, Cli.SucursalOrigen INTO Var_CuentaAhoID, Var_MonedaID, Var_SucCliente
	FROM CREDITOS Cre,
		 CLIENTES Cli
	WHERE Cre.CreditoID = Par_CreditoID
	  AND Cre.ClienteID = Cli.ClienteID;


SET  	Var_CuentaAhoID	:= IFNULL(Var_CuentaAhoID, Entero_Cero);
SET  	Par_Monto		:= IFNULL(Par_Monto, Entero_Cero);
SET  	Var_MonedaID	:= IFNULL(Var_MonedaID, Entero_Cero);

SET  	Var_RefereMov	:= CONVERT(Par_CreditoID, CHAR);
SET  	Var_StrCueAhoID	:= CONVERT(Var_CuentaAhoID, CHAR);

SELECT Suc.IVA INTO Var_IVASucurs
	FROM SUCURSALES Suc
	WHERE Suc.SucursalID = Var_SucCliente;

SET  	Var_IVASucurs	:= IFNULL(Var_IVASucurs, Entero_Cero);

-- Abono a la Cuenta de Ahorro
CALL `CONTAAHORROPRO`(
	Var_CuentaAhoID,	Par_ClienteID,	Aud_NumTransaccion,		Var_FechaSistema,	Var_FechaSistema,
	Nat_Abono,			Par_Monto,		Aho_DescriMov,			Var_RefereMov,		Tip_MovAhoID,
	Var_MonedaID,		Var_SucCliente,	AltaPoliza_SI,			Tip_ConceptoCon,	Var_Poliza,
	AltaPoliza_SI,		Con_AhoCapital,	Nat_Abono,				Var_NumErr,			Var_ErrMen,
	Var_Consecutivo,	Par_EmpresaID,	Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion	);


IF(Var_NumErr != Entero_Cero) THEN
	SET   Var_NumErr := 7;
    SET   Var_ErrMen := 'Error al realizar el pago.';
	LEAVE ManejoErrores;
END IF;

-- Procedimiento del Pago del Credito
CALL `PAGOCREDITOPRO`(
	Par_CreditoID,		Var_CuentaAhoID,	Par_Monto,			Var_MonedaID,		NO_EsPrePago,
	NO_EsFiniquito,		Par_EmpresaID,		Par_SalidaNO,		AltaPoliza_NO,		Var_MontoPagado,
	Var_Poliza,			Var_NumErr,			Var_ErrMen,			Var_Consecutivo,	ModoPagoEfec,
	Con_Origen, 		RespaldaCredSI,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

IF(Var_NumErr != Entero_Cero) THEN
	IF(Var_NumErr != 100) THEN
		LEAVE ManejoErrores;
	END IF;
END IF;

-- Hacemos el Complemento Contable
SELECT Usu.UsuarioId, Usu.SucursalUsuario, CajaID INTO Var_UsuarioID, Var_SucursalID, Var_CajaID
	FROM CAJASVENTANILLA Ven,
		 USUARIOS Usu
	WHERE Ven.UsuarioID = Usu.UsuarioID
	  AND Ven.Estatus = Est_Activo
	  AND Usu.Clave = Par_ClaveUsuario
	  AND Usu.Contrasenia = Par_Contrasenia
	LIMIT 1;

SET  	Var_UsuarioID	:= IFNULL(Var_UsuarioID, Entero_Cero);
SET  	Var_SucursalID	:= IFNULL(Var_SucursalID, Entero_Cero);
SET  	Var_CajaID		:= IFNULL(Var_CajaID, Entero_Cero);

# GENERAR LOS MOVIMIENTOS OPERATIVOS DE LA CAJA: Entrada de Efectivo pOR Deposito a Cuenta
CALL CAJASMOVSALT(
	Var_SucursalID,	Var_CajaID,		Var_FechaSistema,	Aud_NumTransaccion,	Var_MonedaID,
	Par_Monto,		Decimal_Cero,	TipoOperacion,		Var_CajaID,			Var_StrCueAhoID,
	Decimal_Cero,	Decimal_Cero,	Par_SalidaNO,		Var_NumErr, 		Var_ErrMen,
	Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
	Aud_Sucursal,	Aud_NumTransaccion);

SET  	Entero_Cero		:= 0;

IF(Var_NumErr != Entero_Cero) THEN
    SET   Var_NumErr := 8;
    SET   Var_ErrMen := 'Error al realizar el movimiento en caja.';
	LEAVE ManejoErrores;
END IF;

# GENERAR LOS MOVIMIENTOS OPERATIVOS DE LA CAJA: Salida pOR el Pago del Credito
SET   TipoOperacion := 28;

CALL CAJASMOVSALT(
	Var_SucursalID,	Var_CajaID,		Var_FechaSistema,	Aud_NumTransaccion,	Var_MonedaID,
	Par_Monto,		Decimal_Cero,	TipoOperacion,		Var_CajaID,			Var_RefereMov,
	Decimal_Cero,	Decimal_Cero,	Par_SalidaNO,		Var_NumErr, 		Var_ErrMen,
	Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
	Aud_Sucursal,	Aud_NumTransaccion);

SET  	Entero_Cero		:= 0;
IF(Var_NumErr != Entero_Cero) THEN
    SET   Var_NumErr := 9;
    SET   Var_ErrMen := 'Error al realizar el movimiento en caja.';
	LEAVE ManejoErrores;
END IF;

-- Alta de l AS Denominaciones y su Afectacion Contable
CALL DENOMINAMOVSALT(
	Var_SucursalID,	Var_CajaID,			Var_FechaSistema,	Aud_NumTransaccion,	NatMovi,
	DenominacionID,	Par_Monto,			Par_Monto,			Var_MonedaID,		AltaPoliza_NO,
	Var_CajaID,		Var_RefereMov,		Par_SalidaNO,		Par_EmpresaID, 		Aho_DescriMov,
	Par_ClienteID,	Var_Poliza,			Var_NumErr, 	Var_ErrMen,			Entero_Cero,
	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
	Aud_NumTransaccion	);

SET  	Entero_Cero		:= 0;
END ManejoErrores;  -- END del HANDler de Errores


-- Convierte la Salida de acuerdo a lo especificado pOR la Definicion del WS
-- 0 .- Rechazado, 1 .- Realizado
IF(Var_NumErr = Entero_Cero) THEN
	SET  	Var_NumErr	:= 1;
ELSE
	SET  	Var_NumErr	:= Entero_Cero;
END IF;

SET  	Var_TotDeuda := FUNCIONTOTDEUDACRE(Par_CreditoID);

SELECT	SUM(IFNULL(MontoCapAtr, Entero_Cero) + IFNULL(MontoCapOrd, Entero_Cero) + IFNULL(MontoCapVen, Entero_Cero)),
		SUM(IFNULL(MontoIntOrd, Entero_Cero) + IFNULL(MontoIntAtr, Entero_Cero) + IFNULL(MontoIntVen, Entero_Cero)),
		SUM(IFNULL(MontoIntMora, Entero_Cero)),
		SUM(IFNULL(MontoIVA, Entero_Cero)) INTO Var_PagCapita, Var_PagIntOrd, Var_PagIntMora, Var_PagIVATot

	FROM DETALLEPAGCRE Det
	WHERE CreditoID = Par_CreditoID
	  AND NumTransaccion = Aud_NumTransaccion
	  AND FechaPago = Var_FechaSistema;

SET  	Var_PagCapita	:= IFNULL(Var_PagCapita, Entero_Cero);
SET  	Var_PagIntOrd	:= IFNULL(Var_PagIntOrd, Entero_Cero);
SET 	Var_PagIntMora	:= IFNULL(Var_PagIntMora, Entero_Cero);
SET 	Var_PagIVATot	:= IFNULL(Var_PagIVATot, Entero_Cero);
SET 	Var_PagIVAIntMora	:= Entero_Cero;

-- Como no tenemos el detalle del pago del iva, dividido, lo dividimos en iva de interes ordinario y de mora
IF (Var_PagIntMora > Entero_Cero) THEN
	IF(Var_PagIntOrd = Entero_Cero) THEN
		SET 	Var_PagIVAIntMora := Var_PagIVATot;
	ELSE
		SET 	Var_PagIVAIntMora := ROUND(Var_PagIntMora * Var_IVASucurs, 2);
	END IF;
END IF;

SET 	Var_PagIVAIntOrd := Var_PagIVATot - Var_PagIVAIntMora;


IF (Var_NumErr = Entero_Cero)THEN

SET  Var_Es_Valido   := 'false';

ELSE

SET  Var_Es_Valido   := 'true';

END IF;

SELECT 	Var_NumErr  AS NumErr,
		Var_ErrMen  AS ErrMen,
		CONCAT(DATE(Aud_FechaActual),'T',TIME(Aud_FechaActual)) AS FechaAuditoria,
		Aud_NumTransaccion  AS NumTransaccion,
		Var_TotDeuda  AS AdeudoTotal,
		Var_PagCapita  AS CapitalPagado,
		Var_PagIntOrd   AS INTOrdPagado,
		Var_PagIntMora   AS IntMoraPagado,
		Var_PagIVAIntOrd  AS IvaINTOrdPagado,
		Var_PagIVAIntMora   AS IvaIntMoraPagado,
		Var_Es_Valido 		  AS EsValido;

END TerminaStore$$