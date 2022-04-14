-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOFONDEOASIGREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOFONDEOASIGREP`;
DELIMITER $$


CREATE PROCEDURE `CREDITOFONDEOASIGREP`(
	Par_InstitutFondID    	INT(11),
	Par_LineaFondeoID    	INT(11),
	Par_CreditoFondeoID		BIGINT(20),
	Par_FechaAsig       	DATE,
	Par_TipoConsulta		INT(1),

	Par_EmpresaID      		INT(11),
	Aud_Usuario         	INT(11),
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
    )

TerminaStore: BEGIN

DECLARE Entero_Cero         INT(1);
DECLARE Principal           INT(1);
DECLARE BaseCreditoFommur   INT(1);

SET Entero_Cero        	 	:=0;
SET Principal          		:= 1;
SET BaseCreditoFommur   	:= 2;

-- -------------- CONSULTA PRINCIPAL  --------------
IF(Par_TipoConsulta = Principal) THEN

SELECT CASE Cf.FormaSeleccion
            WHEN 'A' THEN 'AUTOMATICO'
            WHEN 'M' THEN 'MANUAL'
            END	AS FormaSeleccion,Cr.CreditoID,Cl.NombreCompleto,Cr.FechaInicio,Cr.FechaVencimien,Cf.MontoCredito,Cf.SaldoCapCre AS SaldoCapital,
       CASE Cl.TipoPersona WHEN 'F' THEN 'FISICA'
            WHEN 'M' THEN 'MORAL'
            WHEN 'A' THEN 'F. ACT. EMP'
            END	AS TIPO, Pr.Descripcion,Dir.DireccionCompleta,Cl.ClienteID,Cl.ActividadBancoMx,Act.Descripcion AS ActDescrip,
        CASE Cl.Sexo
            WHEN 'F' THEN 'FEMENINO'
            WHEN 'M' THEN 'MASCULINO'
            END	AS Sexo,
        CASE Cl.EstadoCivil
            WHEN 'S' THEN 'SOLTERO'
            WHEN 'CS' THEN 'CASADO BIENES SEPARADOS'
            WHEN 'CM' THEN 'CASADO BIENES MANCOMUNADOS'
            WHEN 'CC'THEN 'CASADO BIENES MANCUMUNADOS CON CAPITULACION'
            WHEN 'V'THEN 'VIUDO'
            WHEN 'D'THEN 'DIVORSIADO'
            WHEN 'SE' THEN 'SEPARADO'
            WHEN 'U' THEN 'UNION LIBRE'
            END	AS EstadoCivil,Cr.DestinoCreID,Dest.Descripcion AS Destino ,
            TIME(NOW()) AS HoraEmision
FROM CREDITOS Cr
INNER JOIN CLIENTES AS Cl
            ON Cr.ClienteID = Cl.ClienteID
INNER  JOIN DIRECCLIENTE AS Dir
            ON  Dir.ClienteID = Cl.ClienteID
            AND Dir.Oficial = Oficial
INNER JOIN PRODUCTOSCREDITO AS Pr
            ON  Cr.ProductoCreditoID = Pr.ProducCreditoID
INNER JOIN ACTIVIDADESBMX AS Act
            ON Cl.ActividadBancoMx = Act.ActividadBMXID
INNER JOIN DESTINOSCREDITO AS Dest
            ON Cr.DestinoCreID = Dest.DestinoCreID
INNER JOIN CREDITOFONDEOASIG AS Cf
            ON  Cr.CreditoID = Cf.CreditoID
            AND Cf.InstitutFondeoID = Par_InstitutFondID
            AND Cf.LineaFondeoID = Par_LineaFondeoID
            AND Cf.CreditoFondeoID = Par_CreditoFondeoID
            AND Cf.FechaAsignacion = Par_FechaAsig
            GROUP BY Cf.CreditoID,			Cf.FormaSeleccion,	Cr.CreditoID,			Cl.NombreCompleto,	Cr.FechaInicio,
					 Cr.FechaVencimien,		Cf.MontoCredito,	Cf.SaldoCapCre,			Cl.TipoPersona, 	Pr.Descripcion,
					 Dir.DireccionCompleta,	Cl.ClienteID,		Cl.ActividadBancoMx,	Act.Descripcion,	Cl.Sexo,
					 Cl.EstadoCivil,		Cr.DestinoCreID,	Dest.Descripcion
            ORDER BY Cf.FormaSeleccion DESC, Cr.ProductoCreditoID ;
END IF;

IF(Par_TipoConsulta = BaseCreditoFommur) THEN

SELECT
     Cli.ClienteID AS ClienteSAFI
    ,CASE Cli.TipoPersona WHEN 'A' THEN 'Fisica Con Actividad Empresarial'
                          WHEN 'F' THEN 'Fisica'
                          WHEN 'M' THEN 'Moral'
                          ELSE CONCAT("No definido para Valor: ", Cli.TipoPersona)
    END AS TipoPersona
    ,UPPER(Cli.Titulo) AS Titulo
    ,CONCAT(Cli.PrimerNombre, RTRIM(LTRIM(IFNULL(Cli.SegundoNombre, ''))), RTRIM(LTRIM(IFNULL(Cli.TercerNombre, '')))) AS Nombres
    ,Cli.ApellidoPaterno
    ,Cli.ApellidoMaterno
    ,Cli.NombreCompleto
    ,CASE WHEN Cli.Sexo = 'M' THEN 'Masculino' WHEN Cli.Sexo = 'F' THEN 'Femenino' END AS Sexo
    ,CASE Cli.EstadoCivil	WHEN 'S'  THEN  'Soltero'
                            WHEN 'CS' THEN  'Casado Bienes Separados'
                            WHEN 'CM' THEN  'Casado Bienes Mancomunados'
                            WHEN 'CC' THEN  'Casado Bienes Mancomunados Con Capitulacion'
                            WHEN 'V'  THEN  'Viudo'
                            WHEN 'D'  THEN  'Divorciado'
                            WHEN 'SE' THEN  'Separado'
                            WHEN 'U'  THEN  'Union Libre'
            ELSE CONCAT("No definido valor: ", Cli.EstadoCivil)
    END AS EstadoCivil
    ,IFNULL(Cli.RFCOficial, '') AS RFC
    ,IFNULL(Cli.CURP, '') AS CURP
    ,IFNULL(Cli.Telefono, '') AS TelefonoCasa
    ,IFNULL(Cli.TelefonoCelular, '') AS TelefonoCelular
    ,IFNULL(Cli.Correo, '') AS Correo
    ,IFNULL(GradEsc.Descripcion, '') AS GradoEscolar
    ,IFNULL(TipoIden.Nombre, '') AS TipoIdentificacion
    ,IFNULL(Iden.NumIdentific, '') AS NumeroIdentificacion
    ,Cli.FechaNacimiento
    ,EstNac.Nombre AS EntidadFederativaNacimiento
    ,Cli.OcupacionID AS OcupacionID
    ,Ocup.Descripcion AS DescripcionOcupacion
    ,Cli.LugardeTrabajo AS LugarTrabajo
    ,CONCAT(CAST(Cli.AntiguedadTra AS CHAR), " Año(s)") AS AntiguedadEnTrabajo
    ,Cli.Puesto AS PuestoTrabajo
    ,Cli.ActividadFR
    ,ActFR.Descripcion AS ActividadFRDescripcion
    ,ActFom.ActividadFOMURID
    ,ActFom.Descripcion AS ActividadFOMURDescripcion

    ,TiposDir.Descripcion AS TipoDireccionOficial
    ,Est.Nombre AS EstadoDirOficial
    ,Mun.Nombre AS MunicipioDirOficial
    ,Loc.NombreLocalidad AS LocalidadDirOficial
    ,Col.TipoAsenta AS AsentamientoColoniaDirOficial
    ,Col.Asentamiento AS ColoniaDirOficial
    ,Dir.Calle AS CalleDirOficial
    ,Dir.NumInterior AS NumeroInteriorDirOficial
    ,Dir.NumeroCasa AS NumeroExteriorDirOficial
    ,Dir.CP AS CodigoPostalDirOficial
    ,Dir.DireccionCompleta AS DireccionCompletaDirOficial

    ,Est.Nombre AS EstadoDirNegocio
    ,Mun.Nombre AS MunicipioDirNegocio
    ,Loc.NombreLocalidad AS LocalidadDirNegocio
    ,Col.TipoAsenta AS AsentamientoColoniaDirNegocio
    ,Col.Asentamiento AS ColoniaDirNegocio
    ,Dir.Calle AS CalleDirNegocio
    ,Dir.NumInterior AS NumeroInteriorDirNegocio
    ,Dir.NumeroCasa AS NumeroExteriorDirNegocio
    ,Dir.CP AS CodigoPostalDirNegocio
    ,Dir.DireccionCompleta AS DireccionCompletaDirNegocio

    ,IFNULL(ConCte.NoEmpleados, 0) AS NumeroEmpleados

    ,Cre.SucursalID
    ,Suc.NombreSucurs
    ,Prom.NombrePromotor

    ,Sal.CreditoID
    ,Sal.ProductoCreditoID
    ,Pro.Descripcion AS NombreProducto
    ,IFNULL(Sal.DiasAtraso, 0) AS DiasAtraso
    ,CASE WHEN IFNULL(Sal.DiasAtraso, 0) <= 0   THEN 'CERO DIAS'
          WHEN IFNULL(Sal.DiasAtraso, 0) >= 1    AND IFNULL(Sal.DiasAtraso, 0) <= 7    THEN 'DE 1 A 7 DIAS'
          WHEN IFNULL(Sal.DiasAtraso, 0) >= 8    AND IFNULL(Sal.DiasAtraso, 0) <= 30   THEN 'DE 8 A 30 DIAS'
          WHEN IFNULL(Sal.DiasAtraso, 0) >= 31   AND IFNULL(Sal.DiasAtraso, 0) <= 60   THEN 'DE 31 A 60 DIAS'
          WHEN IFNULL(Sal.DiasAtraso, 0) >= 61   AND IFNULL(Sal.DiasAtraso, 0) <= 90   THEN 'DE 61 A 90 DIAS'
          WHEN IFNULL(Sal.DiasAtraso, 0) >= 91   AND IFNULL(Sal.DiasAtraso, 0) <= 120  THEN 'DE 91 A 120 DIAS'
          WHEN IFNULL(Sal.DiasAtraso, 0) >= 121  AND IFNULL(Sal.DiasAtraso, 0) <= 180  THEN 'DE 121 A 180 DIAS'
          WHEN IFNULL(Sal.DiasAtraso, 0) >= 181  THEN 'DE 181 DIAS EN ADELANTE'
    END AS RangoDeDias
    ,Dest.DestinoCreID AS DestinoCreditoID
    ,Dest.Descripcion AS DestinoCredito
    ,Dest.DestinCredFOMURID AS DestinoFOMURID
    ,DestFom.Descripcion AS DestinoFOMUR
    ,Dest.DestinCredFRID AS DestinoFRID
    ,DestFR.Descripcion AS DestinoFR
    ,CASE Dest.Clasificacion WHEN 'C' THEN 'Comercial'
                             WHEN 'O' THEN 'Consumo'
                             WHEN 'H' THEN 'Hipotecario'
                                        ELSE CONCAT("No definida para valor: ", Dest.Clasificacion)
    END AS TipoDeCredito
    ,IFNULL(Cre.TasaFija, 0.0) AS TasaAnual
    ,ROUND(IFNULL(Cre.TasaFija, 0.0)/12, 2) AS TasaMensual
    ,Cre.FechaInicio AS FechaDesembolso
    ,Cre.FechaVencimien AS FechaVencimiento
    ,Cre.NumAmortizacion AS NumeroCuotas
    ,IFNULL(Cre.GrupoID, 0) AS GrupoID
    ,CASE WHEN IFNULL(Cre.GrupoID, 0) > 0 THEN  Gpo.NombreGrupo ELSE '' END AS NombreGrupo
    ,CASE  WHEN Sal.EstatusCredito = 'V' THEN 'Vigente'
           WHEN Sal.EstatusCredito = 'V' AND IFNULL(Sal.DiasAtraso, 0) > 0 THEN 'Atrasado'
           WHEN Sal.EstatusCredito = 'B' THEN 'Vencido'
           WHEN Sal.EstatusCredito = 'K' THEN 'Castigado'
    END AS Estatus
    ,CASE Sal.FrecuenciaCap WHEN 'S' THEN 'Semanal'
                            WHEN 'C' THEN 'Catorcenal'
                            WHEN 'Q' THEN 'Quincenal'
                            WHEN 'M' THEN 'Mensual'
                            WHEN 'P' THEN 'Periodos'
                            WHEN 'B' THEN 'Bimestral'
                            WHEN 'T' THEN 'Trimestral'
                            WHEN 'R' THEN 'Tetramestral'
                            WHEN 'E' THEN 'Semestral'
                            WHEN 'A' THEN 'Anual'
                            WHEN 'U' THEN 'Pago Unico'
    END AS Frecuencia

    ,CASE Sal.FrecuenciaCap WHEN 'S' THEN 'Semanal'
                            WHEN 'C' THEN 'Catorcenal'
                            WHEN 'Q' THEN 'Quincenal'
                            WHEN 'M' THEN 'Mensual'
                            WHEN 'P' THEN 'Periodos'
                            WHEN 'B' THEN 'Bimestral'
                            WHEN 'T' THEN 'Trimestral'
                            WHEN 'R' THEN 'Tetramestral'
                            WHEN 'E' THEN 'Semestral'
                            WHEN 'A' THEN 'Anual'
                            WHEN 'U' THEN 'Pago Unico'
    END AS ModalidadDePago

    ,00000000000.00 AS GarantiaExhibida
    ,00000000000.00 AS GarantiaAdicional
    ,Sal.MontoCredito AS MontoDesembolsado
    ,SUM(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi) AS SALDO -- SaldoCap
    ,SUM(Sal.SalCapAtrasado + Sal.SalCapVencido ) AS CapitalExigible
    ,SUM(Sal.SalIntAtrasado) AS InteresVigente
    ,SUM(Sal.SalIntProvision) AS InteresProvisionado
    ,SUM(Sal.SalIntVencido) AS InteresVencido
    ,SUM(Sal.SalIntNoConta) AS InteresOrdinarios
    ,SUM(Sal.SalMoratorios) AS  SaldoEnMora
    ,SUM(Sal.SalComFaltaPago +Sal.SaldoComServGar + Sal.SalOtrasComisi) AS  Comisiones
    ,SUM(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi) AS CAPITAL -- SaldoCap

    ,'Columnas de Saldos de acuerdo a SAFI --->>' AS ColumnasSaldosSAFI
    ,SUM(Sal.SalCapVigente) AS SaldoCapVigente
    ,SUM(Sal.SalCapAtrasado)  AS SaldoCapAtrasado
    ,SUM(Sal.SalCapVencido) AS SaldoCapVencido
    ,SUM(Sal.SalCapVenNoExi) AS SaldoCapitalVencidoNoExigible
    ,SUM(Sal.SalIntAtrasado) AS SaldoInteresAtrasado
    ,SUM(Sal.SalIntVencido) AS SaldoInteresVencido
    ,SUM(Sal.SalIntProvision) AS SaldoInteresDevengado
    ,SUM(Sal.SalIntNoConta) AS SaldoInteresDevengadoEnCuentasDeOrden
    ,SUM(Sal.SalMoratorios) AS SaldosMoratorios
    ,SUM(Sal.SalComFaltaPago) AS SaldoComFaltaPago
    ,SUM(Sal.SalOtrasComisi) AS SaldoOtrasComisiones
    ,0.00 AS Ingresos
    ,0.00 AS Egresos
    FROM SALDOSCREDITOS Sal
    INNER JOIN  CREDITOFONDEOASIG Cra  ON Sal.CreditoID =  Cra.CreditoID

    AND Sal.FechaCorte =  Cra.FechaAsignacion AND Cra.LineaFondeoID = Par_LineaFondeoID
    AND Cra.InstitutFondeoID = Par_InstitutFondID
     AND Cra.CreditoFondeoID = Par_CreditoFondeoID

    INNER JOIN CREDITOS Cre ON Cre.CreditoID = Sal.CreditoID
    INNER JOIN CLIENTES Cli ON Cli.ClienteID = Cre.ClienteID
    LEFT JOIN SOCIODEMOGRAL SocGral ON SocGral.ClienteID = Cli.ClienteID
    LEFT JOIN CATGRADOESCOLAR GradEsc ON GradEsc.GradoEscolarID = SocGral.GradoEscolarID
    INNER JOIN ESTADOSREPUB EstNac ON EstNac.EstadoID = Cli.EstadoID

    INNER JOIN PROMOTORES Prom ON Prom.PromotorID = Cli.PromotorActual
    LEFT JOIN GRUPOSCREDITO Gpo ON Gpo.GrupoID = Cre.GrupoID
    INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Cre.SucursalID
    INNER JOIN DESTINOSCREDITO Dest ON Dest.DestinoCreID = Sal.DestinoCreID

    LEFT JOIN DESTINCREDFOMUR DestFom ON DestFom.DestinCredFOMURID = Dest.DestinCredFOMURID
    LEFT JOIN DESTINCREDFR DestFR ON DestFR.DestinCredFRID = Dest.DestinCredFRID

    INNER JOIN PRODUCTOSCREDITO Pro ON Pro.ProducCreditoID = Sal.ProductoCreditoID
    LEFT JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID AND Dir.Oficial = 'S'
    LEFT JOIN TIPOSDIRECCION TiposDir ON TiposDir.TipoDireccionID = Dir.TipoDireccionID
    LEFT JOIN ESTADOSREPUB Est ON Est.EstadoID = Dir.EstadoID
    LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Dir.EstadoID AND Mun.MunicipioID = Dir.MunicipioID
    LEFT JOIN LOCALIDADREPUB Loc ON Loc.EstadoID = Dir.EstadoID AND Loc.MunicipioID = Dir.MunicipioID AND Loc.LocalidadID = Dir.LocalidadID
    LEFT JOIN COLONIASREPUB Col ON Col.ColoniaID = Dir.ColoniaID AND Col.EstadoID = Dir.EstadoID AND Col.MunicipioID = Dir.MunicipioID /*and Col.LocalidadID = Dir.LocalidadID*/
    LEFT JOIN OCUPACIONES Ocup ON Ocup.OcupacionID = Cli.OcupacionID
    LEFT JOIN ACTIVIDADESFR ActFR ON ActFR.ActividadFRID = Cli.ActividadFR
    LEFT JOIN ACTIVIDADESFOMUR ActFom ON ActFom.ActividadFOMURID = Cli.ActividadFOMURID
    LEFT JOIN IDENTIFICLIENTE Iden ON Iden.ClienteID = Cli.ClienteID AND Iden.Oficial = Oficial
    LEFT JOIN TIPOSIDENTI TipoIden ON TipoIden.TipoIdentiID = Iden.TipoIdentiID

    LEFT JOIN DIRECCLIENTE DirNeg ON DirNeg.ClienteID = Cli.ClienteID AND DirNeg.TipoDireccionID	= 	2  -- El tipo de Direccion Negocio tiene ID 2
    LEFT JOIN TIPOSDIRECCION TiposDirNeg ON TiposDirNeg.TipoDireccionID = DirNeg.TipoDireccionID
    LEFT JOIN ESTADOSREPUB EstNeg ON EstNeg.EstadoID = DirNeg.EstadoID
    LEFT JOIN MUNICIPIOSREPUB MunNeg ON MunNeg.EstadoID = DirNeg.EstadoID AND MunNeg.MunicipioID = DirNeg.MunicipioID
    LEFT JOIN LOCALIDADREPUB LocNeg ON LocNeg.EstadoID = DirNeg.EstadoID AND LocNeg.MunicipioID = DirNeg.MunicipioID AND LocNeg.LocalidadID = DirNeg.LocalidadID
    LEFT JOIN COLONIASREPUB ColNeg ON ColNeg.ColoniaID = DirNeg.ColoniaID AND ColNeg.EstadoID = DirNeg.EstadoID AND ColNeg.MunicipioID = DirNeg.MunicipioID /*and ColNeg.LocalidadID = DirNeg.LocalidadID*/
    LEFT JOIN CONOCIMIENTOCTE ConCte ON ConCte.ClienteID = Cli.ClienteID

WHERE Sal.FechaCorte =  Par_FechaAsig
AND Sal.EstatusCredito IN ('V', 'B', 'K')
 GROUP BY Sal.CreditoID, 			Cra.FormaSeleccion, 	GradEsc.Descripcion, 	TipoIden.Nombre, 		Iden.NumIdentific,
		  TiposDir.Descripcion, 	Est.Nombre,				Mun.Nombre,				Loc.NombreLocalidad,	Col.TipoAsenta,
		  Col.Asentamiento,			Dir.Calle,				Dir.NumInterior,		Dir.NumeroCasa,			Dir.CP,
          Dir.DireccionCompleta,	ConCte.NoEmpleados,		Sal.ProductoCreditoID, 	Sal.DiasAtraso, 		Dest.DestinoCreID,
          DestFR.Descripcion, 		Sal.EstatusCredito, 	Sal.FrecuenciaCap,		Sal.MontoCredito
ORDER BY Cre.SucursalID, Sal.CreditoID,Cra.FormaSeleccion DESC;
END IF;

END TerminaStore$$