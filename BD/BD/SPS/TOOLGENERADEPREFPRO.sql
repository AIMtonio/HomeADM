-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TOOLGENERADEPREFPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TOOLGENERADEPREFPRO`;DELIMITER $$

CREATE PROCEDURE `TOOLGENERADEPREFPRO`(
	/* SP DE HERRAMIENTA PARA DESARROLLO, EL CUAL GENERA EL CONTENIDO DE LOS ARCHIVOS DE CARGA PARA
	 * PODER REALIZAR DEPÓSITOS REFERENCIADOS POR DISTINTO TIPO DE CANAL. #AVELASCO #TOOL #HEN #PMONTERO.*/
	Par_InstitucionID		INT(11),		-- NÚMERO DE LA INSTITUCIÓN BANCARIA.
	Par_CtaBancaria			VARCHAR(50),	-- NÚMERO DE CUENTA BANCARIA.
	Par_Fecha				DATE,			-- FECHA DE OPERACIÓN.
	Par_TipoFormato			CHAR(1),		-- B: BANCO E: ESTÁNDAR.
	Par_VersionFormato		INT(11),		-- 1: ANTERIOR 2: ACTUAL.
	Par_TipoCanal			INT(11),		-- 1: CRÉDITO 2: CUENTAS DE AHORRO 3: CLIENTES.
	Par_MontoOperacion		DECIMAL(18,2),	-- MONTO DE LOS MOVIMIENTOS A GENERAR.
	Par_TipoReferencia		INT(11)			-- 1: REF TRADICIONAL (CTAS, CRED, CTES) 2: REF X INSTRUMENTO.
)
TerminaStore:BEGIN
-- DECLARACIÓN DE VARIABLES.

-- DECLARACIÓN DE CONSTANTES.
DECLARE RefTradicional		INT(11);
DECLARE RefXTipoInst		INT(11);
DECLARE TipoCredito			INT(11);
DECLARE TipoCuenta			INT(11);
DECLARE TipoCliente			INT(11);
DECLARE FormatoBanco		CHAR(1);
DECLARE FormatoEstandar		CHAR(1);
DECLARE VersionAnterior		INT(11);
DECLARE VersionActual		INT(11);

-- ASIGNACIÓN DE CONSTANTES.
SET RefTradicional			:= 1;
SET RefXTipoInst			:= 2;
SET TipoCredito				:= 1;
SET TipoCuenta				:= 2;
SET TipoCliente				:= 3;
SET FormatoBanco			:= 'B';
SET FormatoEstandar			:= 'E';
SET VersionAnterior			:= 1;
SET VersionActual			:= 2;

IF(Par_TipoReferencia = RefTradicional)THEN
	IF(Par_TipoFormato = FormatoEstandar)THEN
		IF(Par_TipoCanal = TipoCredito)THEN
			SELECT
				CONCAT(Par_CtaBancaria,'|',Par_Fecha,'|',CRE.CREDITOID,'|PAGO CREDITO ',CRE.CREDITOID,' ' ,UPPER(CTE.NombreCompleto),'|A|',Par_MontoOperacion,'|0|1|E|1') DepRefCreditoS
			FROM CREDITOS CRE
				INNER JOIN CLIENTES CTE ON CRE.ClienteID= CTE.CLIENTEID
			WHERE CRE.ESTATUS IN ('V','B')
				AND CTE.Estatus='A';
		END IF;

		IF(Par_TipoCanal = TipoCuenta)THEN
			SELECT
				CONCAT(Par_CtaBancaria,'|',Par_Fecha,'|',CTA.CuentaAhoID,'|DEPOSITO CTA ',CTA.CuentaAhoID,' ',UPPER(CTE.NombreCompleto),'|A|',Par_MontoOperacion,'|0|2|E|1') DepRefCuentas
			FROM CUENTASAHO CTA
				INNER JOIN CLIENTES CTE ON CTA.ClienteID= CTE.CLIENTEID
			WHERE CTA.ESTATUS='A'
				AND CTA.SaldoDispon=0
				AND CTE.Estatus='A';
		END IF;

		IF(Par_TipoCanal = TipoCliente)THEN
			SELECT
				CONCAT(Par_CtaBancaria,'|',Par_Fecha,'|',CTE.CLIENTEID,'|DEPOSITO CTE ',CTE.CLIENTEID,' ',UPPER(CTE.NombreCompleto),'|A|',Par_MontoOperacion,'|0|3|E|1') DepRefClientes
			FROM CUENTASAHO CTA
				INNER JOIN CLIENTES CTE ON CTA.ClienteID= CTE.CLIENTEID
			WHERE CTA.ESTATUS='A'
				AND CTA.SaldoDispon=0
				AND CTE.Estatus='A';
		END IF;
	END IF;
END IF;

IF(Par_TipoReferencia = RefXTipoInst)THEN
	IF(Par_TipoFormato = FormatoEstandar)THEN
		IF(Par_TipoCanal = TipoCredito)THEN
			SELECT
			CONCAT(Par_CtaBancaria,'|',Par_Fecha,'|',R.Referencia,'|PAGO CREDITO ',R.InstrumentoID,' ' ,UPPER(CTE.NombreCompleto),'|A|',Par_MontoOperacion,'|0|1|E|1') DEPOSITO
			FROM REFPAGOSXINST R
				INNER JOIN CREDITOS CRED ON R.InstrumentoID= CRED.CreditoID AND R.TipoCanalID=1
				INNER JOIN CLIENTES CTE ON CRED.ClienteID= CTE.CLIENTEID
			WHERE CRED.ESTATUS IN ('V','B')
				AND CTE.Estatus='A'
				AND R.InstitucionID=Par_InstitucionID;
		END IF;

		IF(Par_TipoCanal IN (TipoCuenta, TipoCliente))THEN
			SELECT
				CONCAT(Par_CtaBancaria,'|',Par_Fecha,'|',R.Referencia,'|DEPOSITO CTA ',R.InstrumentoID,' ',UPPER(CTE.NombreCompleto),'|A|',Par_MontoOperacion,'|0|2|E|1') DEPOSITO
			FROM REFPAGOSXINST R
				INNER JOIN CUENTASAHO CTA  ON R.InstrumentoID= CTA.CuentaAhoID AND R.TipoCanalID=2
				INNER JOIN CLIENTES CTE ON CTA.ClienteID= CTE.CLIENTEID
			WHERE CTA.ESTATUS='A'
				AND CTE.Estatus='A'
				AND R.InstitucionID=Par_InstitucionID;
		END IF;
	END IF;
END IF;





END TerminaStore$$