-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REIMPRESIONTICKETCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `REIMPRESIONTICKETCON`;
DELIMITER $$

CREATE PROCEDURE `REIMPRESIONTICKETCON`(

	Par_Transaccion			BIGINT(20),
    Par_CreditoID			BIGINT(12),
    Par_TipoConsulta		INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
			)
TerminaStore: BEGIN

DECLARE Entero_Cero			INT(11);
DECLARE Decimal_Cero		DECIMAL(12,2);
DECLARE Cons_Efectivo		VARCHAR(20);
DECLARE EsEfectivo			CHAR(1);
DECLARE Cons_Cheque			VARCHAR(20);
DECLARE EsCheque			CHAR(1);
DECLARE EsDepositoCta		CHAR(1);
DECLARE Cons_DepositoCta	VARCHAR(20);
DECLARE Tipo_Fisica			CHAR(1);
DECLARE Tipo_Moral			CHAR(1);
DECLARE Tipo_FisicaEmp		CHAR(1);
DECLARE Con_Principal		INT(11);
DECLARE Con_Creditos		INT(11);
DECLARE Con_ChequeSCBCobro	INT(11);
DECLARE Con_GastosAnticipos	INT(11);
DECLARE Con_CancelacionSC	INT(11);
DECLARE Con_AportacionSocial	INT(11);
DECLARE Con_DevAportacionSocial	INT(11);
DECLARE Con_GarantiaAdicional	INT(11);


SET Entero_Cero 		:= 0;
SET Decimal_Cero 		:= 0.0;
SET Cons_Efectivo 		:= 'EFECTIVO';
SET EsEfectivo 			:= 'R';
SET Cons_Cheque 		:= 'CHEQUE';
SET EsCheque 			:= 'C';
SET Cons_DepositoCta 	:= 'DEPOSITO A CUENTA';
SET EsDepositoCta 		:= 'D';
SET EsCheque 			:= 'C';
SET Tipo_Fisica			:= 'F';
SET Tipo_Moral			:= 'M';
SET Tipo_FisicaEmp		:= 'A';
SET Con_Principal		:= 1;
SET Con_Creditos		:= 2;
SET Con_ChequeSCBCobro	:= 3;
SET Con_GastosAnticipos	:= 4;
SET Con_CancelacionSC	:= 5;
SET Con_AportacionSocial	:= 6;
SET Con_DevAportacionSocial	:= 7;
SET Con_GarantiaAdicional	:= 8;


IF(IFNULL(Par_TipoConsulta,Entero_Cero) = Con_Principal) THEN
	SELECT
		ReimpresionID,		TransaccionID,
        TipoOperacionID,
        LPAD(R.SucursalID,4,'0') AS SucursalID,
        S.NombreSucurs,
		LPAD(CajaID,6,'0') AS CajaID,
        R.UsuarioID, 		U.Clave,
        U.NombreCompleto AS NombreCajero,
        CONCAT(Fecha,' ',Hora) AS FechaOpera,
		OpcionCajaID,		R.Descripcion,
        CONCAT('$',FORMAT(MontoOperacion,2)) AS MontoOperacion,
        CONCAT('$',FORMAT(Efectivo,2)) Efectivo,
        CONCAT('$',FORMAT(Cambio,2)) Cambio,
		NombrePersona,
        NombreBeneficiario,
        LPAD(R.ClienteID,11,'0') ClienteID,		C.NombreCompleto,	ProspectoID,		EmpleadoID,
		NombreEmpleado,		CuentaIDRetiro,		CuentaIDDeposito,	EtiquetaCtaRetiro,	EtiquetaCtaDepo,
		DesTipoCuenta,		DesTipoCtaDepo,		SaldoActualCta,		Referencia,
		CASE WHEN FormaPagoCobro = EsEfectivo THEN Cons_Efectivo ELSE
		CASE WHEN FormaPagoCobro = EsCheque THEN Cons_Cheque ELSE
		CASE WHEN FormaPagoCobro = EsDepositoCta THEN Cons_DepositoCta END END END
        AS FormaPagoCobro,
			InstitucionID,
		NumCtaInstit,		NumCheque,NombreInstit,PolizaID,R.Telefono,Identificacion,R.FolioIdentificacion,
	FolioPago,CatalogoServID,NombreCatalServ,
    CONCAT('$',FORMAT(MontoServicio,2)) AS MontoServicio,
    CONCAT('$',FORMAT(IVAServicio,2)) AS IVAServicio,
    OrigenServicio,MontoComision,
	TotalCastigado,TotalRecuperado,Monto_PorRecuperar,TipoServServifun,R.EmpresaID,
	MR.Nombre AS NombreMun, ES.Nombre AS NombreEdo,
	CONCAT(ES.Nombre,' ,',MR.Nombre) AS Plaza,
	DescriCorta AS Moneda, RFC
    , CONCAT('****(',FUNCIONNUMLETRAS(MontoOperacion), ' M.N.)****') AS MontoLetra, R.Hora, R.Fecha
    ,S.DirecCompleta AS DireccionSucurs,
    CobraSeguroCuota,
		MontoSeguroCuota,
		IVASeguroCuota
	FROM REIMPRESIONTICKET AS R INNER JOIN
	CLIENTES AS C ON R.ClienteID=C.ClienteID INNER JOIN
	SUCURSALES AS S ON R.SucursalID=S.SucursalID INNER JOIN
	ESTADOSREPUB AS ES ON S.EstadoID=ES.EstadoID INNER JOIN
	MUNICIPIOSREPUB AS MR ON S.MunicipioID=MR.MunicipioID AND S.EstadoID=MR.EstadoID INNER JOIN
	USUARIOS AS U ON R.UsuarioID=U.UsuarioID LEFT JOIN
	MONEDAS AS M ON MonedaIDOperacion=M.MonedaId
	WHERE TransaccionID=Par_Transaccion;
END IF;
IF(IFNULL(Par_TipoConsulta,Entero_Cero) = Con_Creditos) THEN
	SELECT
		ReimpresionID,
        TransaccionID,
        TipoOperacionID,
        LPAD(R.SucursalID,4,'0') AS SucursalID,
        S.NombreSucurs,
		LPAD(CajaID,6,'0') AS CajaID,				R.UsuarioID,
        U.Clave,			U.NombreCompleto AS NombreCajero,
        CONCAT(Fecha,' ',Hora) AS FechaOpera,
		OpcionCajaID,
        R.Descripcion,
        CONCAT('$',FORMAT(MontoOperacion,2)) AS MontoOperacion,
        CONCAT('$',FORMAT(Efectivo,2)) Efectivo,
        CONCAT('$',FORMAT(Cambio,2)) Cambio,
		NombrePersona,
        NombreBeneficiario,
        LPAD(R.ClienteID,11,'0') ClienteID,
        C.NombreCompleto,		EmpleadoID,
		NombreEmpleado,		CuentaIDRetiro,
        CuentaIDDeposito,
        EtiquetaCtaRetiro,	EtiquetaCtaDepo,
		DesTipoCuenta,
        DesTipoCtaDepo,
        SaldoActualCta,
        Referencia,
		CASE WHEN FormaPagoCobro = EsEfectivo THEN Cons_Efectivo ELSE
		CASE WHEN FormaPagoCobro = EsCheque THEN Cons_Cheque ELSE
		CASE WHEN FormaPagoCobro = EsDepositoCta THEN Cons_DepositoCta END END END
		CreditoID,
        ProducCreditoID,
        NombreProdCred,
         CONCAT('$',FORMAT(MontoCredito,2)) MontoCredito,
         CONCAT('$',FORMAT(MontoPorDesem,2)) MontoPorDesem,
		 CONCAT('$',FORMAT(MontoDesemb,2)) MontoDesemb,
        GrupoID,
        NombreGrupo,
        CicloActual,
        CONCAT('$',IFNULL(MontoProximoPago, Decimal_Cero)) MontoProximoPago,
		FechaProximoPago,
        TotalAdeudo,
        CONCAT('$',Capital) Capital,
        CONCAT('$',Interes) Interes,
        CONCAT('$',Moratorios) Moratorios,
		CONCAT('$',Comision) Comision,
        CONCAT('$',ComisionAdmon) ComisionAdmon,
        CONCAT('$',R.IVA) IVA,
        GarantiaAdicional,	InstitucionID,
		NumCtaInstit,		NumCheque,NombreInstit,
        PolizaID,R.Telefono,Identificacion,
        R.FolioIdentificacion,
		FolioPago,CatalogoServID,
        NombreCatalServ,
		MontoServicio,IVAServicio,
        OrigenServicio,MontoComision,
		TotalCastigado,TotalRecuperado,
        Monto_PorRecuperar,TipoServServifun,R.EmpresaID,
		MR.Nombre AS NombreMun, ES.Nombre AS NombreEdo,
		CONCAT(ES.Nombre,' ,',MR.Nombre) AS Plaza,
		DescriCorta AS Moneda,
        M.Descripcion AS MonedaDescripcion,
        C.RFC AS RFCCliente,
		Fecha, Hora, FechaCastigo,
		CobraSeguroCuota,
		MontoSeguroCuota,
		IVASeguroCuota
	FROM REIMPRESIONTICKET AS R INNER JOIN
	CLIENTES AS C ON R.ClienteID=C.ClienteID INNER JOIN
	SUCURSALES AS S ON R.SucursalID=S.SucursalID INNER JOIN
	ESTADOSREPUB AS ES ON S.EstadoID=ES.EstadoID INNER JOIN
	MUNICIPIOSREPUB AS MR ON S.MunicipioID=MR.MunicipioID AND S.EstadoID=MR.EstadoID INNER JOIN
	USUARIOS AS U ON R.UsuarioID=U.UsuarioID LEFT JOIN
	MONEDAS AS M ON MonedaIDOperacion=M.MonedaId
	WHERE TransaccionID=Par_Transaccion
    AND R.CreditoID=Par_CreditoID;
END IF;
IF(IFNULL(Par_TipoConsulta,Entero_Cero) = Con_ChequeSCBCobro) THEN
	SELECT
		TransaccionID,	LPAD(R.SucursalID,4,'0') AS SucursalID,
        S.NombreSucurs,
		LPAD(CajaID,6,'0') AS CajaID,				R.UsuarioID, 		U.Clave,			U.NombreCompleto AS NombreCajero, 	CONCAT(Fecha,' ',Hora) AS FechaOpera,
		OpcionCajaID,
        R.Descripcion,
        CONCAT('$',FORMAT(MontoOperacion,2)) AS MontoOperacion,
        CONCAT('$',FORMAT(Efectivo,2)) Efectivo,
        CONCAT('$',FORMAT(Cambio,2)) Cambio,
		NombrePersona,		NombreBeneficiario,
        LPAD(R.ClienteID,11,'0') ClienteID,		C.NombreCompleto,	ProspectoID,		EmpleadoID,
		NombreEmpleado,		CuentaIDRetiro,		CuentaIDDeposito,	EtiquetaCtaRetiro,	EtiquetaCtaDepo,
		DesTipoCuenta,		DesTipoCtaDepo,		SaldoActualCta,		Referencia,
		CASE WHEN FormaPagoCobro = EsEfectivo THEN Cons_Efectivo ELSE
		CASE WHEN FormaPagoCobro = EsCheque THEN Cons_Cheque ELSE
		CASE WHEN FormaPagoCobro = EsDepositoCta THEN Cons_DepositoCta END END END
		InstitucionID,
		NumCtaInstit,
        NumCheque,
        NombreInstit,PolizaID,R.Telefono,Identificacion,R.FolioIdentificacion,
	FolioPago,CatalogoServID,NombreCatalServ,MontoServicio,IVAServicio,OrigenServicio,MontoComision,
	TotalCastigado,TotalRecuperado,Monto_PorRecuperar,TipoServServifun,R.EmpresaID,
	MR.Nombre AS NombreMun, ES.Nombre AS NombreEdo,
	CONCAT(ES.Nombre,' ,',MR.Nombre) AS Plaza,
	DescriCorta AS Moneda, C.RFC AS RFCCliente,
    Fecha, Hora, CONCAT('****(',FUNCIONNUMLETRAS(MontoOperacion), ' M.N.)****') AS MontoLetra
	FROM REIMPRESIONTICKET AS R INNER JOIN
	CLIENTES AS C ON R.ClienteID=C.ClienteID INNER JOIN
	SUCURSALES AS S ON R.SucursalID=S.SucursalID INNER JOIN
	ESTADOSREPUB AS ES ON S.EstadoID=ES.EstadoID INNER JOIN
	MUNICIPIOSREPUB AS MR ON S.MunicipioID=MR.MunicipioID AND S.EstadoID=MR.EstadoID INNER JOIN
	USUARIOS AS U ON R.UsuarioID=U.UsuarioID LEFT JOIN
	MONEDAS AS M ON MonedaIDOperacion=M.MonedaId
	WHERE TransaccionID=Par_Transaccion
    AND R.CreditoID=Par_CreditoID;
END IF;
IF(IFNULL(Par_TipoConsulta,Entero_Cero) = Con_GastosAnticipos) THEN
	SELECT
		TransaccionID,	LPAD(R.SucursalID,4,'0') AS SucursalID,
        S.NombreSucurs,
		LPAD(CajaID,6,'0') AS CajaID,				R.UsuarioID,
        U.Clave,			U.NombreCompleto AS NombreCajero, 	CONCAT(Fecha,' ',Hora) AS FechaOpera,
		OpcionCajaID,
        R.Descripcion,
        CONCAT('$',FORMAT(MontoOperacion,2)) AS MontoOperacion,
        CONCAT('$',FORMAT(Efectivo,2)) Efectivo,
        CONCAT('$',FORMAT(Cambio,2)) Cambio,
		NombrePersona,		NombreBeneficiario,			EmpleadoID,
		NombreEmpleado,		CuentaIDRetiro,
        CuentaIDDeposito,	EtiquetaCtaRetiro,	EtiquetaCtaDepo,
		DesTipoCuenta,		DesTipoCtaDepo,		SaldoActualCta,		Referencia,
		CASE WHEN FormaPagoCobro = EsEfectivo THEN Cons_Efectivo ELSE
		CASE WHEN FormaPagoCobro = EsCheque THEN Cons_Cheque ELSE
		CASE WHEN FormaPagoCobro = EsDepositoCta THEN Cons_DepositoCta END END END
		InstitucionID,
		NumCtaInstit,
        NumCheque,
        NombreInstit,PolizaID,R.Telefono,R.EmpresaID,
	MR.Nombre AS NombreMun, ES.Nombre AS NombreEdo,
	CONCAT(ES.Nombre,' ,',MR.Nombre) AS Plaza,
	DescriCorta AS Moneda,
    Fecha, Hora, CONCAT('****(',FUNCIONNUMLETRAS(MontoOperacion), ' M.N.)****') AS MontoLetra
	FROM REIMPRESIONTICKET AS R INNER JOIN
	SUCURSALES AS S ON R.SucursalID=S.SucursalID INNER JOIN
	ESTADOSREPUB AS ES ON S.EstadoID=ES.EstadoID INNER JOIN
	MUNICIPIOSREPUB AS MR ON S.MunicipioID=MR.MunicipioID AND S.EstadoID=MR.EstadoID INNER JOIN
	USUARIOS AS U ON R.UsuarioID=U.UsuarioID LEFT JOIN
	MONEDAS AS M ON MonedaIDOperacion=M.MonedaId
	WHERE TransaccionID=Par_Transaccion
    AND R.CreditoID=Par_CreditoID;
END IF;
IF(IFNULL(Par_TipoConsulta,Entero_Cero) = Con_CancelacionSC) THEN
	SELECT
		ReimpresionID,		TransaccionID,		TipoOperacionID,	LPAD(R.SucursalID,4,'0') AS SucursalID, 		S.NombreSucurs,
		LPAD(CajaID,6,'0') AS CajaID,				R.UsuarioID, 		U.Clave,			U.NombreCompleto AS NombreCajero, 	CONCAT(Fecha,' ',Hora) AS FechaOpera,
		OpcionCajaID,		R.Descripcion,
        CONCAT('$',FORMAT(MontoOperacion,2)) AS MontoOperacion,
        CONCAT('$',FORMAT(Efectivo,2)) Efectivo,
        CONCAT('$',FORMAT(Cambio,2)) Cambio,
		NombrePersona,		NombreBeneficiario,	LPAD(R.ClienteID,11,'0') ClienteID,
        C.NombreCompleto,	ProspectoID,		EmpleadoID,
		NombreEmpleado,		CuentaIDRetiro,		CuentaIDDeposito,	EtiquetaCtaRetiro,	EtiquetaCtaDepo,
		DesTipoCuenta,		DesTipoCtaDepo,		SaldoActualCta,		Referencia,
			InstitucionID,
		NumCtaInstit,		NumCheque,NombreInstit,PolizaID,R.Telefono,Identificacion,R.FolioIdentificacion,
	FolioPago,CatalogoServID,NombreCatalServ,MontoServicio,IVAServicio,OrigenServicio,MontoComision,
R.EmpresaID,
	MR.Nombre AS NombreMun, ES.Nombre AS NombreEdo,
	CONCAT(ES.Nombre,' ,',MR.Nombre) AS Plaza,
	DescriCorta AS Moneda, R.Hora, R.Fecha
	FROM REIMPRESIONTICKET AS R INNER JOIN
	CLIENTES AS C ON R.ClienteID=C.ClienteID INNER JOIN
	SUCURSALES AS S ON R.SucursalID=S.SucursalID INNER JOIN
	ESTADOSREPUB AS ES ON S.EstadoID=ES.EstadoID INNER JOIN
	MUNICIPIOSREPUB AS MR ON S.MunicipioID=MR.MunicipioID AND S.EstadoID=MR.EstadoID INNER JOIN
	USUARIOS AS U ON R.UsuarioID=U.UsuarioID LEFT JOIN
	MONEDAS AS M ON MonedaIDOperacion=M.MonedaId
	WHERE TransaccionID=Par_Transaccion;
END IF;

IF(IFNULL(Par_TipoConsulta,Entero_Cero) = Con_AportacionSocial) THEN
	SELECT
		TransaccionID,		TipoOperacionID,		LPAD(R.SucursalID,4,'0') AS SucursalID, 		S.NombreSucurs,
		LPAD(CajaID,6,'0') AS CajaID,				R.UsuarioID, 		U.Clave,			U.NombreCompleto AS NombreCajero,
        CONCAT(Fecha,' ',Hora) AS FechaOpera,OpcionCajaID,		R.Descripcion,		FORMAT(MontoOperacion,2) AS MontoOperacion,		FORMAT(Efectivo,2) Efectivo,
        CASE WHEN FormaPagoCobro = EsEfectivo THEN Cons_Efectivo ELSE
		CASE WHEN FormaPagoCobro = EsCheque THEN Cons_Cheque END END AS FormaPagoCobro,FORMAT(Cambio,2) Cambio,
		NombrePersona,		NombreBeneficiario,	LPAD(R.ClienteID,11,'0') ClienteID,
        C.NombreCompleto,
		NombreEmpleado,		CuentaIDRetiro,		CuentaIDDeposito,	EtiquetaCtaRetiro,	EtiquetaCtaDepo,
		DesTipoCuenta,		DesTipoCtaDepo,		SaldoActualCta,		Referencia,
		CASE WHEN FormaPagoCobro = EsEfectivo THEN Cons_Efectivo ELSE
		CASE WHEN FormaPagoCobro = EsCheque THEN Cons_Cheque ELSE
		CASE WHEN FormaPagoCobro = EsDepositoCta THEN Cons_DepositoCta END END END
        AS FormaPagoCobro,
			InstitucionID,
		R.Telefono,R.EmpresaID,
	MR.Nombre AS NombreMun, ES.Nombre AS NombreEdo,
	CONCAT(ES.Nombre,' ,',MR.Nombre) AS Plaza,
	DescriCorta AS Moneda, MontoPagAportSocial, MontoPendPagoAportSocial, C.RFC AS RFCCliente,
    CONCAT(FUNCIONNUMLETRAS(MontoOperacion), ' M.N.') AS MontoLetra
	FROM REIMPRESIONTICKET AS R INNER JOIN
	CLIENTES AS C ON R.ClienteID=C.ClienteID INNER JOIN
	SUCURSALES AS S ON R.SucursalID=S.SucursalID INNER JOIN
	ESTADOSREPUB AS ES ON S.EstadoID=ES.EstadoID INNER JOIN
	MUNICIPIOSREPUB AS MR ON S.MunicipioID=MR.MunicipioID AND S.EstadoID=MR.EstadoID INNER JOIN
	USUARIOS AS U ON R.UsuarioID=U.UsuarioID LEFT JOIN
	MONEDAS AS M ON MonedaIDOperacion=M.MonedaId
	WHERE TransaccionID=Par_Transaccion;
END IF;
IF(IFNULL(Par_TipoConsulta,Entero_Cero) = Con_DevAportacionSocial) THEN
	SELECT
		ReimpresionID,
        TransaccionID,
        TipoOperacionID,
        LPAD(R.SucursalID,4,'0') AS SucursalID,
        S.NombreSucurs,
		LPAD(CajaID,6,'0') AS CajaID,				R.UsuarioID,
        U.Clave,			U.NombreCompleto AS NombreCajero,
        CONCAT(Fecha,' ',Hora) AS FechaOpera,
		OpcionCajaID,
        R.Descripcion,
        CONCAT('$',FORMAT(MontoOperacion,2)) AS MontoOperacion,
        CONCAT('$',FORMAT(Efectivo,2)) Efectivo,
        CONCAT('$',FORMAT(Cambio,2)) Cambio,
		NombrePersona,
        NombreBeneficiario,
        LPAD(R.ClienteID,11,'0') ClienteID,
        C.NombreCompleto,		EmpleadoID,
		NombreEmpleado,		CuentaIDRetiro,
        CuentaIDDeposito,
        EtiquetaCtaRetiro,	EtiquetaCtaDepo,
		DesTipoCuenta,
        DesTipoCtaDepo,
        SaldoActualCta,
        Referencia,
		CASE WHEN FormaPagoCobro = EsEfectivo THEN Cons_Efectivo ELSE
		CASE WHEN FormaPagoCobro = EsCheque THEN Cons_Cheque ELSE
		CASE WHEN FormaPagoCobro = EsDepositoCta THEN Cons_DepositoCta END END END
        AS FormaPagoCobro,
		CreditoID,
        ProducCreditoID,
        NombreProdCred,
         CONCAT('$',FORMAT(MontoCredito,2)) MontoCredito,
         CONCAT('$',FORMAT(MontoPorDesem,2)) MontoPorDesem,
		 CONCAT('$',FORMAT(MontoDesemb,2)) MontoDesemb,
        GrupoID,
        NombreGrupo,
        CicloActual,
        CONCAT('$',IFNULL(MontoProximoPago, Decimal_Cero)) MontoProximoPago,
		FechaProximoPago,
        TotalAdeudo,
        CONCAT('$',Capital) Capital,
        CONCAT('$',Interes) Interes,
        CONCAT('$',Moratorios) Moratorios,
		CONCAT('$',Comision) Comision,
        CONCAT('$',ComisionAdmon) ComisionAdmon,
        CONCAT('$',R.IVA) IVA,
        GarantiaAdicional,	InstitucionID,
		NumCtaInstit,		NumCheque,NombreInstit,
        PolizaID,R.Telefono,Identificacion,
        R.FolioIdentificacion,
		FolioPago,CatalogoServID,
        NombreCatalServ,
		MontoServicio,IVAServicio,
        OrigenServicio,MontoComision,
		TotalCastigado,TotalRecuperado,
        Monto_PorRecuperar,TipoServServifun,R.EmpresaID,
		MR.Nombre AS NombreMun, ES.Nombre AS NombreEdo,
		CONCAT(ES.Nombre,' ,',MR.Nombre) AS Plaza,
		DescriCorta AS Moneda, C.RFC AS RFCCliente,
		Fecha, Hora, FechaCastigo
	FROM REIMPRESIONTICKET AS R INNER JOIN
	CLIENTES AS C ON R.ClienteID=C.ClienteID INNER JOIN
	SUCURSALES AS S ON R.SucursalID=S.SucursalID INNER JOIN
	ESTADOSREPUB AS ES ON S.EstadoID=ES.EstadoID INNER JOIN
	MUNICIPIOSREPUB AS MR ON S.MunicipioID=MR.MunicipioID AND S.EstadoID=MR.EstadoID INNER JOIN
	USUARIOS AS U ON R.UsuarioID=U.UsuarioID LEFT JOIN
	MONEDAS AS M ON MonedaIDOperacion=M.MonedaId
	WHERE TransaccionID=Par_Transaccion
    AND R.CreditoID=Par_CreditoID;
END IF;

IF(IFNULL(Par_TipoConsulta,Entero_Cero) = Con_GarantiaAdicional) THEN
	SELECT
		TransaccionID,		TipoOperacionID,
        LPAD(R.SucursalID,4,'0') AS SucursalID,
        S.NombreSucurs,
		LPAD(CajaID,6,'0') AS CajaID,				R.UsuarioID,
        U.Clave,
        U.NombreCompleto AS NombreCajero,
        CONCAT(Fecha,' ',Hora) AS FechaOpera,OpcionCajaID,
        R.Descripcion,
        FORMAT(MontoOperacion,2) AS MontoOperacion,
        FORMAT(Efectivo,2) Efectivo,
		CASE WHEN FormaPagoCobro = EsEfectivo THEN Cons_Efectivo ELSE
		CASE WHEN FormaPagoCobro = EsCheque THEN Cons_Cheque ELSE
		CASE WHEN FormaPagoCobro = EsDepositoCta THEN Cons_DepositoCta END END END,
        FORMAT(Cambio,2) Cambio,
		NombrePersona,		LPAD(R.ClienteID,11,'0') ClienteID,
        CuentaIDRetiro,
        	EtiquetaCtaRetiro,
			Referencia,
		CASE WHEN FormaPagoCobro = EsEfectivo THEN Cons_Efectivo ELSE
		CASE WHEN FormaPagoCobro = EsCheque THEN Cons_Cheque ELSE
		CASE WHEN FormaPagoCobro = EsDepositoCta THEN Cons_DepositoCta END END END
        AS FormaPagoCobro,
			InstitucionID,
		R.Telefono,R.EmpresaID,
	MR.Nombre AS NombreMun, ES.Nombre AS NombreEdo,
	CONCAT(ES.Nombre,' ,',MR.Nombre) AS Plaza,
	DescriCorta AS Moneda, MontoPagAportSocial, MontoPendPagoAportSocial
	FROM REIMPRESIONTICKET AS R INNER JOIN
	CLIENTES AS C ON R.ClienteID=C.ClienteID INNER JOIN
	SUCURSALES AS S ON R.SucursalID=S.SucursalID INNER JOIN
	ESTADOSREPUB AS ES ON S.EstadoID=ES.EstadoID INNER JOIN
	MUNICIPIOSREPUB AS MR ON S.MunicipioID=MR.MunicipioID AND S.EstadoID=MR.EstadoID INNER JOIN
	USUARIOS AS U ON R.UsuarioID=U.UsuarioID LEFT JOIN
	MONEDAS AS M ON MonedaIDOperacion=M.MonedaId
	WHERE TransaccionID=Par_Transaccion;
END IF;
END TerminaStore$$