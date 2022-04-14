-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REIMPTICKETCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `REIMPTICKETCON`;DELIMITER $$

CREATE PROCEDURE `REIMPTICKETCON`(
/*SP para la consulta de los datos para la reimpresion del  ticket*/
	Par_Transaccion			BIGINT(20),			# Numero de Transacion
	Par_CreditoID			BIGINT(12),			# Numero de Credito
	Par_TipoConsulta		INT(11),			# Tipo de Consulta
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_TipoCuentaID			INT(11);		# Tipo de Cuenta de Ahorro
	-- Declaracion de constantes
	DECLARE Decimal_Cero				DECIMAL(12,2);	# DECIMAL Cero
	DECLARE Entero_Cero					INT(11);		# Entero Cero
	DECLARE Con_AbonoCTA				INT(11);		# Consulta para operaciones de abono a cta
	DECLARE Con_RetiroCTA				INT(11);		# Consulta para operaciones de retiro a cta
	DECLARE Con_RevRetiroCTA			INT(11);		# Consulta para operaciones de reversa retiro a cta
	DECLARE Con_RevAbonoCTA				INT(11);		# Consulta para operaciones de reversa abono a cta


	-- Asignacion de constantes
	SET Entero_Cero						:= 0;
	SET Decimal_Cero					:= 0.0;
	SET Con_AbonoCTA					:= 2;
	SET Con_RetiroCTA					:= 1;
	SET Con_RevRetiroCTA				:= 31;
	SET Con_RevAbonoCTA					:= 32;

	/**
	Consulta: 1 - 2
	Descripcion: Consulta para operaciones de abono y retiro a CTA.
	**/
	IF(Par_TipoConsulta = Con_AbonoCTA OR Par_TipoConsulta = Con_RetiroCTA) THEN
		SET Var_TipoCuentaID := (SELECT IF(REM.TipoOperacionID = Con_AbonoCTA, CTA1.TipoCuentaID, CTA2.TipoCuentaID)
									FROM
										REIMPRESIONTICKET AS REM LEFT JOIN
										CUENTASAHO AS CTA1 ON REM.CuentaIDDeposito = CTA1.CuentaAhoID LEFT JOIN
										CUENTASAHO AS CTA2 ON REM.CuentaIDRetiro = CTA2.CuentaAhoID
										WHERE TransaccionID =Par_Transaccion);

		SELECT
			REM.TransaccionID,		REM.TipoOperacionID,
			LPAD(REM.SucursalID,4,'0') AS SucursalID,
			LPAD(REM.CajaID,4,'0') AS CajaID,
			LPAD(REM.UsuarioID,4,'0') AS UsuarioID,
			USU.Clave,
			REM.Fecha,
			REM.Hora,					REM.OpcionCajaID,	REM.Descripcion,
			FORMAT(REM.MontoOperacion,2) AS MontoOperacion,
			FORMAT(REM.Efectivo,2) AS Efectivo,
			FORMAT(REM.Cambio,2) AS Cambio,
			REM.NombrePersona,
			LPAD(REM.ClienteID,10,'0') AS ClienteID,
			LPAD(REM.CuentaIDDeposito,11,'0') AS CuentaIDDeposito,
			LPAD(REM.CuentaIDRetiro,11,'0') AS CuentaIDRetiro,
			REM.EtiquetaCtaRetiro,
			REM.EtiquetaCtaDepo,
			FORMAT(REM.SaldoActualCta,2) AS SaldoActualCta,
			REM.Referencia,
			FORMAT((REM.SaldoActualCta-REM.MontoOperacion),2) AS SaldoInicial,
			MN.DescriCorta AS Moneda,
			TIP.Descripcion AS TipoCuenta,
			USU.NombreCompleto AS NombreCajero,
			IF(REM.FormaPagoCobro = 'R','EFECTIVO','CHEQUE') AS FormaPagoCobro,
			SUC.NombreSucurs,
			CONCAT(REM.Fecha,' ',REM.Hora) AS FechaOpera,
			PLA.Nombre AS Plaza,
			CONCAT('****(',FUNCIONNUMLETRAS(MontoOperacion), ' M.N.)****') AS MontoLetra
			FROM
				REIMPRESIONTICKET AS REM INNER JOIN
				USUARIOS AS USU ON REM.UsuarioID = USU.UsuarioID INNER JOIN
				MONEDAS AS MN ON REM.MonedaIDOperacion = MN.MonedaId LEFT JOIN
				TIPOSCUENTAS AS TIP ON TIP.TipoCuentaID = Var_TipoCuentaID INNER JOIN
				SUCURSALES AS SUC ON REM.SucursalID = SUC.SucursalID LEFT JOIN
				PLAZAS AS PLA ON SUC.PlazaID=PLA.PlazaID
				WHERE TransaccionID =Par_Transaccion;
	END IF;

	IF(Par_TipoConsulta = Con_RevRetiroCTA OR Par_TipoConsulta = Con_RevAbonoCTA) THEN
		IF(Par_TipoConsulta = Con_RevRetiroCTA) THEN
			SET Var_TipoCuentaID := (SELECT CTA2.TipoCuentaID
										FROM
											REVERSASOPER AS REV INNER JOIN
											REIMPRESIONTICKET AS REM ON REV.TransaccionID = REM.TransaccionID LEFT JOIN
											CUENTASAHO AS CTA2 ON REM.CuentaIDRetiro = CTA2.CuentaAhoID
											WHERE REV.NumTransaccion =Par_Transaccion);
		  ELSE
			SET Var_TipoCuentaID := (SELECT CTA.TipoCuentaID
										FROM
											REVERSASOPER AS REV INNER JOIN
											REIMPRESIONTICKET AS REM ON REV.TransaccionID = REM.TransaccionID LEFT JOIN
											CUENTASAHO AS CTA ON REM.CuentaIDDeposito = CTA.CuentaAhoID
											WHERE REV.NumTransaccion =Par_Transaccion);
		END IF;


		SELECT
				REV.NumTransaccion AS TransaccionID,		REM.TipoOperacionID,
				LPAD(REM.SucursalID,4,'0') AS SucursalID,
				LPAD(REM.CajaID,4,'0') AS CajaID,
				LPAD(REM.UsuarioID,4,'0') AS UsuarioID,
				USU.Clave,
				REM.Fecha,
				REV.Hora,
				REM.OpcionCajaID,
				REM.Descripcion,
				FORMAT(REV.Monto,2) AS MontoOperacion,
				FORMAT(REV.Efectivo,2) AS Efectivo,
				FORMAT(REV.Cambio,2) AS Cambio,
				REM.NombrePersona,
				LPAD(REM.ClienteID,10,'0') AS ClienteID,
				LPAD(REM.CuentaIDDeposito,11,'0') AS CuentaIDDeposito,
				LPAD(REM.CuentaIDRetiro,11,'0') AS CuentaIDRetiro,
				REM.EtiquetaCtaRetiro,
				REM.EtiquetaCtaDepo,
				FORMAT(REM.SaldoActualCta,2) AS SaldoActualCta,
				REV.Referencia,
				FORMAT((REM.SaldoActualCta-REM.MontoOperacion),2) AS SaldoInicial,
				MN.DescriCorta AS Moneda,
				TIP.Descripcion AS TipoCuenta,
				TIP.Descripcion AS TipoCuenta2,
				USU.NombreCompleto AS NombreCajero,
				IF(REM.FormaPagoCobro = 'R','EFECTIVO','CHEQUE') AS FormaPagoCobro,
				SUC.NombreSucurs,
				CONCAT(REM.Fecha,' ',REM.Hora) AS FechaOpera,
				PLA.Nombre AS Plaza,
				CONCAT('****(',FUNCIONNUMLETRAS(REV.Monto), ' M.N.)****') AS MontoLetra,
				REM.TransaccionID AS TransOri
				FROM
					REVERSASOPER AS REV INNER JOIN
					REIMPRESIONTICKET AS REM ON REV.TransaccionID = REM.TransaccionID INNER JOIN
					USUARIOS AS USU ON REV.UsuarioID = USU.UsuarioID INNER JOIN
					MONEDAS AS MN ON REM.MonedaIDOperacion = MN.MonedaId LEFT JOIN
					TIPOSCUENTAS AS TIP ON TIP.TipoCuentaID = Var_TipoCuentaID INNER JOIN
					SUCURSALES AS SUC ON REV.SucursalID = SUC.SucursalID LEFT JOIN
					PLAZAS AS PLA ON SUC.PlazaID=PLA.PlazaID
					WHERE REV.NumTransaccion =Par_Transaccion;
	END IF;


END TerminaStore$$