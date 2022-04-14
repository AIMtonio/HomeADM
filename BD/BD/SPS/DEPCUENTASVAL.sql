-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPCUENTASVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPCUENTASVAL`;
DELIMITER $$

CREATE PROCEDURE `DEPCUENTASVAL`(
	Par_CuentaAhoID			BIGINT(12),		-- Cuenta de Ahorro a Validar
	Par_MontoMov			DECIMAL(18,2),	-- Monto del Movimiento
	Par_Fecha				DATE,			-- Fecha del Movimiento
	Par_TipoVal				INT(1),			-- Tipo de Validacion(1.-Ventanilla, 2.-Depositos Referenciados)
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

-- Declaracion de Constantes
DECLARE EnteroCero				INT(1);
DECLARE SalidaSi				CHAR(1);
DECLARE Cadena_Vacia			CHAR(1);
DECLARE ValidaSi				CHAR(1);
DECLARE Ventanilla				INT(1);
DECLARE DepositosRefer			INT(1);
DECLARE CanalVentanilla			INT(1);
DECLARE MedioDepositosRefer		INT(1);
DECLARE TipoUDIS				INT(1);
DECLARE NatAbono				CHAR(1);
DECLARE EstCta_Activa			CHAR(1);
DECLARE EstCta_Bloqueada		CHAR(1);
DECLARE EstCta_Cancelada		CHAR(1);
DECLARE EstCta_Inactiva			CHAR(1);
DECLARE EstCta_Registrada		CHAR(1);

-- Declaracion de Variables
DECLARE Var_DirecOficial		CHAR(1);
DECLARE Var_IdenOficial			CHAR(1);
DECLARE Var_ConoCteCta			CHAR(1);
DECLARE Var_CheckListExp		CHAR(1);
DECLARE Var_LimAboMensual		CHAR(1);
DECLARE Var_AbonosHasta			INT(11);
DECLARE Var_PerAbonAdicional	CHAR(1);
DECLARE Var_AbonoAdiciHasta		INT(11);
DECLARE Var_LimSaldo			CHAR(1);
DECLARE Var_SaldoHasta			DECIMAL(18,2);
DECLARE Var_CantAbonos			DECIMAL(18,2);
DECLARE Var_AbonosHastaCon		DECIMAL(18,2);
DECLARE Var_TipCamConInt		DECIMAL(18,2);
DECLARE Var_AbonosAdicCon		DECIMAL(18,2);
DECLARE Var_SaldoHastaCon		DECIMAL(18,2);
DECLARE Var_SaldoActual			DECIMAL(18,2);
DECLARE Var_InicioMes			DATE;
DECLARE Var_MesAnioLimEx        DATE;
DECLARE Var_MesAnioDep          DATE;
DECLARE Var_Estatus				CHAR(1);

-- Asignacion de Constantes
SET EnteroCero			:=	0;						-- Constante Entero Cero
SET SalidaSi			:=	'S';					-- Constante Salida SI
SET Cadena_Vacia		:=	'';						-- Constante Cadena Vacía
SET Ventanilla			:=	1;						-- Validaciones de Ventanilla
SET DepositosRefer		:=	2;						-- Validaciones de Depositos Referenciados.
SET CanalVentanilla		:=	1;						-- Canal de Acceso Ventanilla
SET MedioDepositosRefer	:=	5;						-- Medio de Acceso Depositos Referenciados
SET TipoUDIS			:=	4;						-- Tipo de Divisa UDIS.
SET ValidaSi			:=	'S';					-- Constante SI.
SET NatAbono			:=	'A';                    -- Naturaleza Abono.
SET EstCta_Activa		:=	'A';					-- ESTATUS DE LA CUENTA ACTIVA
SET EstCta_Bloqueada	:=	'B';					-- ESTATUS DE LA CUENTA BLOQUEADA
SET EstCta_Cancelada	:=	'C';					-- ESTATUS DE LA CUENTA CANCELADA
SET EstCta_Inactiva		:=	'I';					-- ESTATUS DE LA CUENTA INACTIVA
SET EstCta_Registrada	:=	'R';					-- ESTATUS DE LA CUENTA REGISTRADA


ManejoErrores:BEGIN

SET Par_ErrMen	:='';

SELECT 	tipo.DireccionOficial,		tipo.IdenOficial,	        tipo.ConCuenta,		            tipo.CheckListExpFisico,	tipo.LimAbonosMensuales,
		tipo.AbonosMenHasta,		tipo.PerAboAdi,         	tipo.AboAdiHas,	                tipo.LimSaldoCuenta,		tipo.SaldoHasta,
		cta.Estatus
INTO	Var_DirecOficial,			Var_IdenOficial,			Var_ConoCteCta,					Var_CheckListExp,			Var_LimAboMensual,
		Var_AbonosHasta,			Var_PerAbonAdicional,		Var_AbonoAdiciHasta,			Var_LimSaldo,				Var_SaldoHasta,
		Var_Estatus
	FROM CUENTASAHO cta
		INNER JOIN TIPOSCUENTAS tipo ON cta.TipoCuentaID = tipo.TipoCuentaID
	WHERE cta.CuentaAhoID = Par_CuentaAhoID;


SET Var_InicioMes	:=	CONCAT(EXTRACT(YEAR FROM Par_Fecha),'-',EXTRACT(MONTH FROM Par_fecha),'-01');
-- Se obtiene el Valor de las UDIS
SELECT 	ROUND(TipCamComInt,2)
INTO	Var_TipCamConInt
	FROM MONEDAS
	WHERE MonedaID = TipoUDIS;

#VALIDAR EL CAPITAL NETO DE LA IDENTIDAD
IF(Par_TipoVal = CanalVentanilla)THEN
	CALL OPERCAPITALNETOVALPRO(Par_CuentaAhoID,		Par_MontoMov, 			"V", 					"AC",						"N",
							Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,    		Aud_FechaActual,
                            Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,           Aud_NumTransaccion);

	IF(Par_NumErr!=EnteroCero)THEN
		LEAVE ManejoErrores;
	END IF;

END IF;


# VALIDAR SI LA CUENTA ESTA ACTIVA PARA RECIBIR ABONOS.
IF(IFNULL(Var_Estatus, Cadena_Vacia)!=EstCta_Activa)THEN
	SET Par_NumErr := 1;
	SET Par_ErrMen := CONCAT('La Cuenta se Encuentra ',
							CASE Var_Estatus
								WHEN EstCta_Bloqueada THEN 'Bloqueada'
								WHEN EstCta_Cancelada THEN 'Cancelada'
								WHEN EstCta_Inactiva THEN 'Inactiva'
								WHEN EstCta_Registrada THEN 'Registrada'
							ELSE Cadena_Vacia END,
							'. No se puede hacer Movimientos.');
	LEAVE ManejoErrores;
END IF;
-- Si la cuenta existe en la tabla LIMEXCUENTAS
IF EXISTS (SELECT CuentaAhoID,Motivo, Fecha
			FROM  LIMEXCUENTAS
			WHERE CuentaAhoID = Par_CuentaAhoID
			AND   YEAR(Fecha) = YEAR(Par_Fecha)
			AND   MONTH(Fecha) = MONTH(Par_Fecha)    )THEN
                 SET Par_NumErr :=2;
                 SET Par_ErrMen :=CONCAT('La Cuenta ', Par_CuentaAhoID, ' ha superado los limites, ya no puede recibir ningun deposito.');
           LEAVE ManejoErrores;
ELSEIF(Var_LimAboMensual = ValidaSi) THEN

	SELECT	SUM(CantidadMov)
	INTO	Var_CantAbonos
		FROM CUENTASAHOMOV
		WHERE CuentaAhoID = Par_CuentaAhoID AND NatMovimiento = NatAbono AND Fecha >= Var_InicioMes AND Fecha <= Par_Fecha;
	-- Se Obtine el Valor real del Limite de los Abonos Mensuales
	SET Var_AbonosHastaCon	:=	Var_TipCamConInt * Var_AbonosHasta;
	-- Se Suma la cantidad del Movimiento a los Abonos que ha tenido durante el Mes.
	SET Var_CantAbonos	:=	IFNULL(Var_CantAbonos,EnteroCero) + Par_MontoMov;
	-- Verificamos si se supera el Limite de Abonos Mensuales.
	IF(Var_CantAbonos > Var_AbonosHastaCon) THEN
		-- Si se Supera Validamos si Permite Abonos Adicionales.
		IF(Var_PerAbonAdicional = ValidaSi) THEN
			SET Var_AbonosAdicCon	= Var_TipCamConInt * Var_AbonoAdiciHasta;
			-- Se Valida si El Movimiento Supera el Limite de Abonos Adicionales.
			IF(Var_CantAbonos > Var_AbonosAdicCon) THEN
				SET Par_NumErr	:=	3;
				SET Par_ErrMen	:=	CONCAT('La Cuenta ', Par_CuentaAhoID,' ha Superado el Li­mite de Abonos Permitidos en el Mes.');
				 LEAVE ManejoErrores;
			END IF;

		ELSE
			SET Par_NumErr	:=	3;
			SET Par_ErrMen	:=	CONCAT('La Cuenta ', Par_CuentaAhoID,' ha Superado el Li­mite de Abonos Permitidos en el Mes.');
			 LEAVE ManejoErrores;
		END IF;

	END IF;


IF(Var_LimSaldo =	ValidaSi) THEN
	SET Var_SaldoHastaCon := Var_SaldoHasta * Var_TipCamConInt;
	SELECT	Saldo
	INTO	Var_SaldoActual
		FROM CUENTASAHO
	WHERE CuentaAhoID	=	Par_CuentaAhoID;

	SET Var_SaldoActual = Var_SaldoActual + Par_MontoMov;

IF(Var_SaldoActual > Var_SaldoHastaCon) THEN
	SET Par_NumErr	:=	4;
	SET Par_ErrMen	:=	CONCAT('La Cuenta ', Par_CuentaAhoID,' Supera el Li­mite de Saldo Permitido.');
	 LEAVE ManejoErrores;
END IF;

END IF;

SET Par_NumErr	:=	0;
SET Par_ErrMen	:=	'Validacion Exitosa.';

-- fin del if del if exists
END IF;


END ManejoErrores;

IF(Par_Salida = SalidaSi) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'InstitucionID' AS control,
				0 AS consecutivo;
END IF;


END TerminaStored$$