-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERSIONPAGAREREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERSIONPAGAREREP`;DELIMITER $$

CREATE PROCEDURE `INVERSIONPAGAREREP`(
	Par_InversionID				INT(11),		-- ID de la inversion
	Par_TipoConsulta			INT(11),		-- Numero de la consulta para el reporte
	Par_UsuarioID				INT(11),		-- ID del usuario

	Par_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Par_Fecha				DATE,			-- Parametro de auditoria Fecha actual
	Par_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Par_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Par_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Par_NumeroTransaccion		BIGINT			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	DECLARE Var_ContClienteID 			VARCHAR(250);
	DECLARE Var_ContInversionID			VARCHAR(250);
	DECLARE Var_ContNombreCliente		VARCHAR(250);
	DECLARE Var_ContCURP				VARCHAR(250);
	DECLARE Var_ContRFC					VARCHAR(250);
	DECLARE Var_ContInteresRetener      VARCHAR(250);
	DECLARE Var_ContTipoInversion		VARCHAR(250);
	DECLARE Var_ContPlazaID				VARCHAR(250);
	DECLARE Var_ContNombrePlaza			VARCHAR(250);
	DECLARE Var_TasaInteresAnual		DECIMAL(12,2);
	DECLARE Var_FechaSistema			DATE;
	DECLARE Var_Si						CHAR(1);


	DECLARE	Tipo_PagareInv				INT(11);
	DECLARE	Cadena_Vacia				CHAR(1);
	DECLARE	Fecha_Vacia					DATE;
	DECLARE	Entero_Cero					INT(11);
	DECLARE	Var_FechaOp					DATE;
	DECLARE	Var_NomSuc					VARCHAR(50);
	DECLARE	Var_NumInversion			VARCHAR(15);
	DECLARE	Var_InvRenovada				INT(11);
	DECLARE	Var_ReferenceInv			VARCHAR(50);
	DECLARE	Var_MontoInv				DECIMAL(12,2);
	DECLARE	Var_NombreCte				VARCHAR(200);
	DECLARE	Var_RFC						VARCHAR(13);
	DECLARE	Var_CuentaAhoID				BIGINT(12);
	DECLARE	Var_Moneda					VARCHAR(80);
	DECLARE	Var_Plazo					INT(11);
	DECLARE	Var_FechaVto				DATE;
	DECLARE	Var_TasaBruta				DECIMAL(12,2);
	DECLARE	Var_ISR						DECIMAL(12,2);
	DECLARE	Var_TasaNeta				DECIMAL(12,2);
	DECLARE	Var_ImporteRet				DECIMAL(12,2);
	DECLARE	Var_InteresNeto				DECIMAL(12,2);
	DECLARE	Var_MontoRecibir			DECIMAL(12,2);
	DECLARE	Var_MontoRetener			DECIMAL(12,2);
	DECLARE Var_TipoPer					CHAR(1);
	DECLARE Var_RazonSocial				VARCHAR(150);
	DECLARE Var_RfcOficial				VARCHAR(13);
	DECLARE Var_RepLegalEmpr			VARCHAR(150);	-- Representante Legal de la empresa
	DECLARE Var_primerNom				VARCHAR(50);	-- nombres del representante legal
	DECLARE Var_restoNomb				VARCHAR(150);	-- Apellidos del representante legal
	DECLARE Var_EscPublica				VARCHAR(20);	-- ID de la escritura publica
	DECLARE Var_NumNotaria				VARCHAR(20);	-- Numero de notarias donde se realizo la escritura
	DECLARE Var_NombreNotario			VARCHAR(200);	-- Nombre del notario
	DECLARE Var_FechaEsc				VARCHAR(200);	-- Fecha de registro de la escritura
	DECLARE Var_DirecCliente			VARCHAR(200);	-- Direccion del cliente en formato especifico
	DECLARE Var_numRECA					VARCHAR(200);	-- Numero de registro RECA de la inversion
	DECLARE Var_DirecEmpresa			VARCHAR(200);	-- Direccion de la empresa en formato especifico
	DECLARE Var_NuevaFechaSis			VARCHAR(100);	-- Fecha del sistema en formato especifico
	DECLARE Var_FechaSisLetra			VARCHAR(100);	-- Fecha en letra
	DECLARE Var_numExtLetra				VARCHAR(100);	-- Numero exterior en letra
	DECLARE Var_numIntLetra				VARCHAR(100);	-- Numero interior en letra
	DECLARE Var_DirecCliente1			VARCHAR(150);	-- primera parte de la direccion en formato especifico
	DECLARE Var_DirecCliente2			VARCHAR(150);	-- segunda parte de la
	DECLARE Var_FechaEscLetra			VARCHAR(150);	-- fecha de registro de la escritura en letra
	DECLARE Var_DirecEscPub				VARCHAR(150);	-- direccion de la notaria
	DECLARE Var_DirecRegPub				VARCHAR(150);	-- direccion del registro publico
	DECLARE Var_FolioRegPub				VARCHAR(50);	-- folio del registro publico
    DECLARE Var_LongLinea				INT(11);		-- Total de caracteres por linea (para parrafo de encabezado)
    DECLARE Var_NumLineas				INT(11);		-- Numero de renglones para parrafo de encabezado

-- variables no existentes que son requeridos en prpt certificado de inversion
DECLARE Var_tasaPromocion				VARCHAR(200); 	-- nombre del ejectivo que captura la inversióny solicita una tasa de promoción
DECLARE Var_vencimientoTp				DATE; 			-- fecha de vencimiento de la tasa de promoción
DECLARE Var_tasaAnualp					DECIMAL(12,2); 	-- tasa anual de promoción pactada
DECLARE Var_renConTasaAnual				VARCHAR(50);	-- poner "Si" cuando la inversión se renueva con tasa anual fija de Promoción, de locontratio poner "No"
DECLARE Var_ejecutivoSobretasa			VARCHAR(50);	-- nombre del ejecutivo que autoriza sobretasa
DECLARE Var_vencimientoS 				DATE;			-- fecha de vencimiento de la sobretasa anual
DECLARE Var_sobretasaAnual				DECIMAL(12,2); 	-- sobre tasa anual pactada con el cliente
DECLARE Var_renSobreTasa				VARCHAR(50);	-- renovacion sobretasa Si o No
DECLARE Var_Mensual						VARCHAR(50);	-- Si la reinversion es mensual S/N
DECLARE Var_Encabezado					VARCHAR(600);	-- Encabezado del contrato


	DECLARE Pagare 					INT(11);
	DECLARE ContDepPlazoFijo 		INT(11);
	DECLARE Con_Beneficiarios		INT(11);
	DECLARE Con_PoderNotarial		INT(11);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Con_CertPlazoFijo		INT(11);
	DECLARE Con_PersonaMoral		CHAR(1);
	DECLARE Con_PersonaFisica		CHAR(1);
	DECLARE Con_ContPlazoFijoTam	INT(11);

	DECLARE InversionAyE			INT(11);

SET Pagare 					:= 2;
SET ContDepPlazoFijo 		:= 3;
SET Con_Beneficiarios		:= 4;
SET Con_PoderNotarial 		:= 5;
SET	InversionAyE			:= 7;
SET Decimal_Cero			:= 0.00;
SET Con_CertPlazoFijo		:= 9;
SET Con_ContPlazoFijoTam	:=10;


SET	Tipo_PagareInv		:=	6;
SET	Cadena_Vacia		:=	'';
SET	Fecha_Vacia			:=	'1900-01-01';
SET	Entero_Cero			:=	0;
SET Con_PersonaMoral		:='M';
SET Con_PersonaFisica		:='F';


SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
SET Var_Si				:= 'S';



IF(Par_TipoConsulta = Pagare) THEN
	SELECT LPAD(CONVERT(Cli.ClienteID, CHAR),10,0) AS ClienteID,
		  LPAD(CONVERT(InversionID, CHAR),10,0) AS InversionID,
		  NombreCompleto AS NombreCliente,
		  LPAD(CONVERT(Suc.SucursalID, CHAR), 3,0) AS SucursalID,
		  NombreSucurs AS Sucursal,
		  LPAD(CONVERT(Inv.CuentaAhoID, CHAR), 11, 0) AS CuentaAho,
		  Tii.Descripcion AS Inversion,
		  Inv.Reinvertir AS TipoInversion,
		  Mon.Descripcion AS TipoMoneda,
		  FechaInicio , FechaVencimiento ,
		  FORMAT(Monto, 2) AS Monto,
		  CONVERT(Plazo,CHAR) AS Plazo,
		  CONVERT(Tasa, CHAR) AS Tasa,
		  CONVERT(Inv.TasaISR,CHAR) AS TasaISR,
		  CONVERT(TasaNeta, CHAR)   AS TasaNeta,
		  FORMAT(InteresGenerado, 4) AS InteresGenerado,
		  CONVERT(FORMAT(InteresRecibir, 2), CHAR) AS InteresRecibir,
		  InteresRetener AS InteresRetener,
		  FORMAT((Monto + InteresRecibir), 2) AS totalFinal,
		  ValorGat AS Gat,
		  Dir.DireccionCompleta,
		  FUNCIONNUMLETRAS(Monto) AS MontoLetras,
		  Var_FechaSistema AS FechaSistema,
								(SELECT FORMAT(Tas.ConceptoInversion,2)
								FROM TASASINVERSION Tas
								INNER JOIN  MONTOINVERSION Mont ON 	Mont.TipoInversionID = Tas.TipoInversionID
								INNER JOIN  DIASINVERSION	Dia ON Dia.TipoInversionID=Tas.TipoInversionID
									WHERE Tas.TipoInversionID=Inv.TipoInversionID
										AND Tas.DiaInversionID 	 = Dia.DiaInversionID
										AND Tas.MontoInversionID = Mont.MontoInversionID
										AND Mont.PlazoInferior	<=Inv.Monto
										AND Mont.PlazoSuperior	>=Inv.Monto
										AND Dia.PlazoInferior	<=Inv.Plazo
										AND Dia.PlazoSuperior	>=Inv.Plazo)AS Var_TasaInteresAnual,
		IFNULL(Inv.ValorGatReal,Decimal_Cero) AS GatReal

		FROM INVERSIONES Inv,
			 SUCURSALES Suc,
			 CATINVERSION Tii,
			 MONEDAS Mon,
			 CLIENTES Cli,
			 DIRECCLIENTE Dir
		WHERE   Inv.InversionID		= Par_InversionID
		  AND   Suc.SucursalID		= Inv.Sucursal
		  AND	Inv.TipoInversionID	= Tii.TipoInversionID
		  AND	Inv.MonedaID		= Mon.MonedaId
		  AND	Inv.ClienteID		= Cli.ClienteID
		  AND   Dir.ClienteID = Cli.ClienteID
		  AND   Dir.Oficial = Var_Si;

END IF;


IF(Par_TipoConsulta = ContDepPlazoFijo) THEN


	SELECT  LPAD(CONVERT(Inv.InversionID, CHAR),11,0) AS InversionID,
		LPAD(CONVERT(Cli.ClienteID, CHAR),10,0) AS ClienteID,
		Cli.NombreCompleto AS NombreCliente, Cli.CURP, Cli.RFC, Inv.InteresRetener,
			CASE Inv.Reinvertir
						WHEN "C" THEN "SOLO CAPITAL"
						WHEN "CI" THEN "CAPITAL + INTERES"
						WHEN "N" THEN "NINGUNA"
				END AS TipoInversion
		INTO Var_ContInversionID,		Var_ContClienteID, 			Var_ContNombreCliente,
			 Var_ContCURP, 	    		Var_ContRFC,         		Var_ContInteresRetener,
			 Var_ContTipoInversion
		FROM INVERSIONES Inv
			INNER JOIN CLIENTES Cli ON Cli.ClienteID=Inv.ClienteID
			WHERE Inv.InversionID=Par_InversionID;

		SELECT LPAD(CONVERT(Pla.PlazaID, CHAR), 3,0) AS PlazaID,
			CASE Pla.Nombre
			WHEN "Oaxaca Centro" THEN "OAXACA"
			END AS NombrePlaza
		INTO Var_ContPlazaID, Var_ContNombrePlaza
			FROM SUCURSALES Suc
           INNER JOIN PLAZAS Pla ON Suc.Sucursal = Pla.Sucursal
			WHERE Pla.Sucursal = Par_Sucursal
			LIMIT 1;

       SELECT  Var_ContInversionID,			Var_ContClienteID, 			Var_ContNombreCliente,
			   Var_ContCURP, 	    		Var_ContRFC,         		Var_ContInteresRetener,
			   Var_ContTipoInversion,		Var_ContPlazaID, 			Var_ContNombrePlaza;
END IF;


IF  (Par_TipoConsulta = Con_Beneficiarios) THEN
	SELECT Ben.NombreCompleto,	Ben.Domicilio,	Ben.TelefonoCasa,	CASE WHEN CHAR_LENGTH(TRIM(Ben.NombreCompleto)) > 0  THEN ''
																		 ELSE Cli.NombreCompleto END	AS NombreBeneficiario,
			Ben.Porcentaje,	Tip.Descripcion
			FROM  CLIENTES Cli  RIGHT JOIN
				 BENEFICIARIOSINVER Ben ON Ben.ClienteID = Cli.ClienteID,
				 TIPORELACIONES Tip
			WHERE Tip.TipoRelacionID = Ben.TipoRelacionID
			 AND Ben.InversionID = Par_InversionID;

END IF;


IF  (Par_TipoConsulta = Con_PoderNotarial) THEN
		SELECT	CONCAT(Suc.TituloGte,' ', Usu.NombreCompleto) AS NombreGerente,		Suc.PoderNotarialGte
		FROM SUCURSALES Suc,
			 USUARIOS Usu
		WHERE SucursalID = Par_Sucursal
		AND Usu.UsuarioID = Suc.NombreGerente;
END IF;

IF(Par_TipoConsulta = Tipo_PagareInv) THEN
	SELECT	Inv.FechaInicio,		Suc.NombreSucurs,	Inv.InversionRenovada,		Inv.Monto,
			CONCAT(	Cli.PrimerNombre,
					CASE	WHEN	IFNULL(Cli.SegundoNombre,	Cadena_Vacia)	<> Cadena_Vacia	THEN	CONCAT(' ', Cli.SegundoNombre)
							ELSE	Cadena_Vacia
					END,
					CASE	WHEN	IFNULL(Cli.TercerNombre,	Cadena_Vacia)	<> Cadena_Vacia	THEN	CONCAT(' ', Cli.TercerNombre)
							ELSE	Cadena_Vacia
					END,
					CONCAT(' ', ApellidoPaterno),
					CONCAT(' ', ApellidoMaterno)),
                    Cli.RFC,	Inv.CuentaAhoID,	Mon.Descripcion,	Inv.Plazo,				Inv.FechaVencimiento,
                    Inv.Tasa,	Inv.TasaISR,		Inv.TasaNeta,		Inv.InteresGenerado ,	Inv.InteresRetener,
                    Cli.TipoPersona,				Cli.RazonSocial,	Cli.RFCOficial
            INTO
            Var_FechaOp,	Var_NomSuc,			Var_InvRenovada,	Var_MontoInv,		Var_NombreCte,
            Var_RFC,		Var_CuentaAhoID,	Var_Moneda,			Var_Plazo,			Var_FechaVto,
            Var_TasaBruta,	Var_ISR,			Var_TasaNeta,		Var_InteresNeto,	Var_MontoRetener,
			Var_TipoPer,	Var_RazonSocial,	Var_RfcOficial
	FROM	INVERSIONES Inv
	INNER JOIN	CLIENTES	Cli	ON	Cli.ClienteID	=	Inv.ClienteID
	INNER JOIN	SUCURSALES	Suc	ON	Suc.SucursalID	=	Inv.Sucursal
	INNER JOIN	MONEDAS		Mon	ON	Mon.MonedaId	=	Inv.MonedaID
	WHERE	Inv.InversionID	=	Par_InversionID;

	SET	Var_NomSuc			:=	IFNULL(Var_NomSuc,	Cadena_Vacia);
	SET	Var_NumInversion	:=	IFNULL(LPAD(CONVERT(Par_InversionID, CHAR),10,0),	Cadena_Vacia);
	SET	Var_ReferenceInv	:=	CASE	WHEN	IFNULL(Var_InvRenovada, Entero_Cero)	<> Entero_Cero	THEN	'Reinversion'
										ELSE	'Inversion'
								END;
	SET	Var_MontoInv		:=	IFNULL(Var_MontoInv,	Decimal_Cero);
	SET	Var_NombreCte		:=	IFNULL(Var_NombreCte,	Cadena_Vacia);
	SET	Var_RFC				:=	IFNULL(Var_RFC,			Cadena_Vacia);
	SET	Var_Moneda			:=	IFNULL(Var_Moneda,		Cadena_Vacia);
	SET	Var_Plazo			:=	IFNULL(Var_Plazo,		Entero_Cero);
	SET	Var_FechaVto		:=	IFNULL(Var_FechaVto,	Fecha_Vacia);
	SET	Var_TasaBruta		:=	IFNULL(Var_TasaBruta,	Decimal_Cero);
	SET	Var_ISR				:=	IFNULL(Var_ISR,	Decimal_Cero);
	SET	Var_TasaNeta		:=	IFNULL(Var_TasaNeta,	Decimal_Cero);
	SET	Var_ImporteRet		:=	Var_MontoInv*Var_ISR/100;
	SET	Var_InteresNeto		:=	IFNULL(Var_InteresNeto,	Decimal_Cero);
	SET	Var_MontoRecibir	:=	Var_MontoInv + Var_InteresNeto;
    SET Var_MontoRetener	:=	IFNULL(Var_MontoRetener, Decimal_Cero);


	--  --> Vladimir Jz
	IF(Var_TipoPer  = 'M') THEN
		SET Var_NombreCte = Var_RazonSocial;
        SET Var_RFC = Var_RfcOficial;
    END IF;
	--   <-- Ticket 3642

	SELECT	CASE	WHEN	IFNULL(Var_FechaOp, Fecha_Vacia)	<> Cadena_Vacia	THEN	Var_FechaOp
					ELSE	Cadena_Vacia
			END	AS	Var_FechaOp,
			Var_NomSuc,		Var_NumInversion,		Var_ReferenceInv,	Var_MontoInv,	Var_NombreCte,
			Var_RFC,
			CASE	WHEN	IFNULL(Var_CuentaAhoID, Entero_Cero)	<>	Entero_Cero	THEN	Var_CuentaAhoID
					ELSE	Cadena_Vacia
			END	AS	Var_CuentaAhoID,
			Var_Moneda,		Var_Plazo,
			CASE	Var_FechaVto
					WHEN	Fecha_Vacia	THEN	Cadena_Vacia
					ELSE	Var_FechaVto
			END	AS	Var_FechaVto,
			Var_TasaBruta,	Var_ISR,			Var_TasaNeta,		FORMAT(Var_ImporteRet,2)	AS Var_ImporteRet,
			Var_InteresNeto,Var_MontoRecibir,	Var_MontoRetener,	Var_TipoPer,				Var_RazonSocial,
            Var_RfcOficial;
END IF;


IF(Par_TipoConsulta = InversionAyE) THEN
	SELECT	LPAD(CONVERT(Cli.ClienteID, CHAR),10,0) AS Var_ClienteID,
			LPAD(CONVERT(Inv.CuentaAhoID, CHAR), 11, 0) AS Var_CuentaAho,
			CONCAT( Cli.PrimerNombre,
				CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) <> Cadena_Vacia	THEN CONCAT(" ",Cli.SegundoNombre)
					ELSE	Cadena_Vacia
				END,
				CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) <> Cadena_Vacia	THEN CONCAT(" ",Cli.TercerNombre)
					ELSE	Cadena_Vacia
				END,
				CONCAT(" ",Cli.ApellidoPaterno),
				CONCAT(" ",ApellidoMaterno)
			) AS Var_NombreCte,
			Tii.Descripcion	AS	Var_NomProduc,
			Inv.ValorGat AS Var_Gat,
			'PASIVA'	AS	Var_TipoOp,
			CONVERT(Tasa, CHAR) AS Var_Tasa,
			LPAD(CONVERT(InversionID, CHAR),10,0) AS Var_InversionID,
			(SELECT NombreRepresentante FROM PARAMETROSSIS) AS Var_RepLegal,
			FORMATEAFECHACONTRATO(Var_FechaSistema) AS Var_FechEmi,
			IFNULL(Cli.TipoPersona, Cadena_Vacia)	AS Var_TipoPersona,
			IFNULL(Cli.Titulo, Cadena_Vacia)	AS Var_Titulo,
			IFNULL(Cli.RazonSocial, Cadena_Vacia) AS Var_RazonSocial,

		  LPAD(CONVERT(Suc.SucursalID, CHAR), 3,0) AS SucursalID,
		  NombreSucurs AS Sucursal,
		  Tii.Descripcion AS Inversion,
		  Inv.Reinvertir AS TipoInversion,
		  Mon.Descripcion AS TipoMoneda,
			FechaVencimiento ,
		  FORMAT(Monto, 2) AS Monto,
		  CONVERT(Plazo,CHAR) AS Plazo,
		  CONVERT(Inv.TasaISR,CHAR) AS TasaISR,
		  CONVERT(TasaNeta, CHAR)   AS TasaNeta,
		  FORMAT(InteresGenerado, 4) AS InteresGenerado,
		  CONVERT(FORMAT(InteresRecibir, 2), CHAR) AS InteresRecibir,
		  InteresRetener AS InteresRetener,
		  FORMAT((Monto + InteresRecibir), 2) AS totalFinal,
		  Dir.DireccionCompleta,
		  FUNCIONNUMLETRAS(Monto) AS MontoLetras,
		  Var_FechaSistema AS FechaSistema,
								(SELECT FORMAT(Tas.ConceptoInversion,2)
								FROM TASASINVERSION Tas
								INNER JOIN  MONTOINVERSION Mont ON 	Mont.TipoInversionID = Tas.TipoInversionID
								INNER JOIN  DIASINVERSION	Dia ON Dia.TipoInversionID=Tas.TipoInversionID
									WHERE Tas.TipoInversionID=Inv.TipoInversionID
										AND Tas.DiaInversionID 	 = Dia.DiaInversionID
										AND Tas.MontoInversionID = Mont.MontoInversionID
										AND Mont.PlazoInferior	<=Inv.Monto
										AND Mont.PlazoSuperior	>=Inv.Monto
										AND Dia.PlazoInferior	<=Inv.Plazo
										AND Dia.PlazoSuperior	>=Inv.Plazo)AS Var_TasaInteresAnual,
		IFNULL(Inv.ValorGatReal,Decimal_Cero) AS GatReal
		FROM INVERSIONES Inv,
			 SUCURSALES Suc,
			 CATINVERSION Tii,
			 MONEDAS Mon,
			 CLIENTES Cli,
			 DIRECCLIENTE Dir

		WHERE   Inv.InversionID		= Par_InversionID
		  AND   Suc.SucursalID		= Inv.Sucursal
		  AND	Inv.TipoInversionID	= Tii.TipoInversionID
		  AND	Inv.MonedaID		= Mon.MonedaId
		  AND	Inv.ClienteID		= Cli.ClienteID
		  AND   Dir.ClienteID = 	Cli.ClienteID
		  AND   Dir.Oficial = Var_Si;

END IF;

-- consulta para certificado plazo fijo tamazula
IF(Par_TipoConsulta = Con_CertPlazoFijo) THEN
	-- asignar aqui los valores cuando ya existan
	SET Var_tasaPromocion  		:= 	Cadena_Vacia;
	SET Var_vencimientoTp 		:= 	Fecha_Vacia;
	SET Var_tasaAnualp			:=	Decimal_Cero;
	SET Var_renConTasaAnual		:= 	Cadena_Vacia;
	SET Var_ejecutivoSobretasa	:= 	Cadena_Vacia;
	SET Var_vencimientoS 		:= 	Fecha_Vacia;
	SET Var_sobretasaAnual		:=	Decimal_Cero;
	SET Var_renSobreTasa		:= 	Cadena_Vacia;
	SET Var_Mensual				:= 	Cadena_Vacia;
    -- fin signacion variables

	 SELECT cli.TipoPersona
		INTO Var_TipoPer
		FROM CLIENTES cli,
			INVERSIONES inv
		WHERE inv.ClienteID=cli.ClienteID
		AND inv.InversionID=Par_InversionID;

    IF(Var_TipoPer=Con_PersonaMoral)THEN
		SELECT cli.RazonSocial, ctas.NombreCompleto
        INTO Var_RazonSocial, Var_NombreCte
		FROM CLIENTES cli,
			INVERSIONES inv INNER JOIN CUENTASPERSONA ctas ON inv.CuentaAhoID=ctas.CuentaAhoID AND ctas.EsApoderado='S'
		WHERE inv.ClienteID=cli.ClienteID
		AND inv.InversionID=Par_InversionID ORDER BY PersonaID ASC LIMIT 1;
    ELSE
		SET Var_NombreCte := (SELECT cli.NombreCompleto
							FROM CLIENTES cli,
                            INVERSIONES inv
                            WHERE inv.ClienteID=cli.ClienteID
                            AND inv.InversionID=Par_InversionID);
    END IF;

	SELECT suc.NombreSucurs, LPAD(CONVERT(inv.ClienteID, CHAR), 11,0) AS ClienteID, inv.CuentaAhoID, LPAD(CONVERT(inv.InversionID, CHAR), 11,0) AS InversionID,
		 Var_NombreCte AS Nom,
		DATE_FORMAT(inv.FechaVencimiento,'%d/%m/%Y') AS fechaVencimiento, CONCAT(inv.Plazo,' DÍAS') AS plazo,
		DATE_FORMAT(inv.FechaInicio,'%d/%m/%Y') AS fechaOperacion, inv.FechaInicio, inv.Tasa,
        inv.Monto,FUNCIONNUMLETRAS(inv.Monto) AS MontoLetras, inv.ValorGat,
        usu.NombreCompleto, cat.NumRegistroRECA, Var_TipoPer,
        Var_tasaPromocion, Var_vencimientoTp,Var_tasaAnualp,Var_renConTasaAnual,
        Var_ejecutivoSobretasa,Var_vencimientoS,Var_sobretasaAnual,Var_renSobreTasa,
        cat.Reinversion, cat.Reinvertir,Var_Mensual
	FROM INVERSIONES inv,
			SUCURSALES suc,
            CLIENTES cli,
            USUARIOS usu,
            CATINVERSION cat
	WHERE inv.Sucursal=suc.SucursalID
    AND inv.ClienteID=cli.ClienteID
    AND inv.UsuarioID=usu.UsuarioID
    AND cat.TipoInversionID=inv.TipoInversionID
    AND inv.InversionID=Par_InversionID;
END IF;

-- Consulta para contrato plazo fijo Tamazula
IF(Par_TipoConsulta = Con_ContPlazoFijoTam) THEN
	-- nuevas consultas para contrato inversion a plazo fijo tamazula
    SELECT cli.TipoPersona,LPAD(CONVERT(inv.InversionID, CHAR),11,0)
    INTO Var_TipoPer,Var_ContInversionID
	FROM CLIENTES cli,
		INVERSIONES inv
	WHERE inv.ClienteID=cli.ClienteID
    AND inv.InversionID=Par_InversionID;
	-- Condicion para evaluar si el cliente es persona moral o no
    IF(Var_TipoPer = Con_PersonaMoral)THEN

        SELECT NombreRepresentante, SUBSTRING_INDEX(NombreRepresentante,' ',2) AS primerNom,
			REPLACE(NombreRepresentante, SUBSTRING_INDEX(NombreRepresentante,' ',2),'') AS restoNom
		INTO Var_RepLegalEmpr,Var_primerNom,Var_restoNomb
		FROM PARAMETROSSIS;

        SELECT
			FNNUMVIVIENDALETRA(dir.NumeroCasa) AS numLetraExt,
            dir.NumInterior,
			CONCAT(dir.Calle,', # ',IFNULL(dir.NumeroCasa,' ')),
			IF(dir.NumInterior='' OR dir.NumInterior=NULL,'',CONCAT(' INT. ',dir.NumInterior,' (',FNNUMVIVIENDALETRA(dir.NumInterior),')') ),
			CONCAT(col.Asentamiento,', ',
				loc.NombreLocalidad,', ',
				mun.nombre,', ',
				est.nombre,', MÉXICO, C.P. ',
				dir.CP) AS direcComplet
		INTO Var_numExtLetra,Var_numIntLetra,Var_DirecCliente1,Var_DirecCliente2,Var_DirecCliente
		FROM ESTADOSREPUB est
            INNER JOIN MUNICIPIOSREPUB mun ON mun.EstadoID=est.EstadoID
            INNER JOIN LOCALIDADREPUB loc ON loc.MunicipioID=mun.MunicipioID
										  AND loc.EstadoID=est.EstadoID
            INNER JOIN COLONIASREPUB col ON col.MunicipioID=mun.MunicipioID
										 AND col.EstadoID=est.EstadoID
            INNER JOIN DIRECCLIENTE dir ON dir.MunicipioID=mun.MunicipioID
										AND dir.ColoniaID=col.ColoniaID
										AND dir.LocalidadID=loc.LocalidadID
                                        AND dir.EstadoID=est.EstadoID
                                        AND dir.Fiscal='S',
			INVERSIONES inv
		WHERE inv.ClienteID=dir.ClienteID
			AND inv.InversionID=Par_InversionID ORDER BY dir.DireccionID ASC LIMIT 1;

        SELECT EscrituraPublic, Notaria, NomNotario,DATE_FORMAT(FechaEsc,'%d/%m/%Y'), FNFECHATEXTO(FechaEsc),FolioRegPub
        INTO Var_EscPublica,Var_NumNotaria,Var_NombreNotario,Var_FechaEsc,Var_FechaEscLetra,Var_FolioRegPub
        FROM ESCRITURAPUB esc,
			INVERSIONES inv
        WHERE esc.ClienteID=inv.ClienteID
        AND inv.InversionID=Par_InversionID LIMIT 1;

        -- direccion escritura publica

		SELECT CONCAT(mun.Nombre,', ',est.Nombre) AS direcEscritura
				INTO Var_DirecEscPub
				FROM ESTADOSREPUB est
					INNER JOIN MUNICIPIOSREPUB mun ON est.EstadoID=mun.EstadoID
					INNER JOIN ESCRITURAPUB esc ON est.EstadoID=esc.EstadoIDEsc AND mun.MunicipioID=esc.LocalidadEsc,
					INVERSIONES inv
				WHERE  esc.ClienteID=inv.ClienteID
				AND inv.InversionID=Par_InversionID LIMIT 1;

		-- direccion registro publico
		SELECT CONCAT(mun.Nombre,', ',est.Nombre) AS direcRegistro
				INTO Var_DirecRegPub
				FROM ESTADOSREPUB est
					INNER JOIN MUNICIPIOSREPUB mun ON est.EstadoID=mun.EstadoID
					INNER JOIN ESCRITURAPUB esc ON est.EstadoID=esc.EstadoIDReg AND mun.MunicipioID=esc.LocalidadRegPub,
					INVERSIONES inv
				WHERE  esc.ClienteID=inv.ClienteID
				AND inv.InversionID=Par_InversionID LIMIT 1;

        SELECT cli.RazonSocial, ctas.NombreCompleto
        INTO Var_RazonSocial, Var_NombreCte
		FROM CLIENTES cli,
			INVERSIONES inv INNER JOIN CUENTASPERSONA ctas ON inv.CuentaAhoID=ctas.CuentaAhoID AND ctas.EsApoderado='S'
		WHERE inv.ClienteID=cli.ClienteID
		AND inv.InversionID=Par_InversionID ORDER BY PersonaID ASC LIMIT 1;

        SELECT cinv.NumRegistroRECA
        INTO Var_numRECA
		FROM INVERSIONES inv,
			CATINVERSION cinv
		WHERE cinv.TipoInversionID=inv.TipoInversionID
		AND InversionID=Par_InversionID;

        SELECT CONCAT(mun.Nombre,', ',est.Nombre) AS ciudad,DATE_FORMAT(par.FechaSistema,'%d/%m/%Y') , FNFECHATEXTO(par.FechaSistema)
        INTO Var_DirecEmpresa,Var_NuevaFechaSis,Var_FechaSisLetra
		FROM ESTADOSREPUB AS est
			INNER JOIN MUNICIPIOSREPUB AS mun ON mun.EstadoID=est.EstadoID
			INNER JOIN COLONIASREPUB AS col ON col.MunicipioID=mun.MunicipioID,
			INSTITUCIONES inst,
			PARAMETROSSIS par,
			INVERSIONES inv
		WHERE  est.EstadoID=inst.EstadoEmpresa
		AND mun.MunicipioID=inst.MunicipioEmpresa
		AND col.ColoniaID=inst.ColoniaEmpresa
		AND par.InstitucionID=inst.InstitucionID
		AND par.EmpresaID=inv.EmpresaID
		AND inv.InversionID=Par_InversionID;

        -- Armado del encabezado del contrato para persona moral
        SET Var_LongLinea:=118; -- numero de caracteres por linea, incluyendo caracteres del codigo RTF
        SET Var_NumLineas:=5;	-- numero de renglones del parrafo
        SET Var_Encabezado:=CONCAT('{\\rtf1 Contrato de {\\b INVERSIÓN A PLAZO FIJO} que celebran por un parte FINANCIERA TAMAZULA S. A. DE C. V. S. F. P., a quien en lo',
							' sucesivo se denominará “LA SOCIEDAD”, representada en este acto por su representante legal, el C. {\\b ',Var_RepLegalEmpr,'}',
                            ' y por otra parte {\\b ',Var_RazonSocial,'},  por medio de su representante legal {\\b ',
                            Var_NombreCte,'} en lo sucesivo "EL CLIENTE" de conformidad con las siguientes declaraciones y clausulas: '
							);
		-- NOTA: Al final de la cadena no debe ponerse la llave de cierre "}" ya que esta se agrega en pentaho
	ELSE
		SELECT NombreRepresentante, SUBSTRING_INDEX(NombreRepresentante,' ',2) AS primerNom,
			REPLACE(NombreRepresentante, SUBSTRING_INDEX(NombreRepresentante,' ',2),'') AS restoNom
		INTO Var_RepLegalEmpr,Var_primerNom,Var_restoNomb
		FROM PARAMETROSSIS;

        SELECT
			FNNUMVIVIENDALETRA(dir.NumeroCasa) AS numLetraExt,
            dir.NumInterior,
			CONCAT(dir.Calle,', # ',IFNULL(dir.NumeroCasa,' ')),
			IF(dir.NumInterior='' OR dir.NumInterior=NULL,'',CONCAT(' INT. ',dir.NumInterior,' (',FNNUMVIVIENDALETRA(dir.NumInterior),')') ),
			CONCAT(col.Asentamiento,', ',
				loc.NombreLocalidad,', ',
				mun.nombre,', ',
				est.nombre,', MÉXICO, C.P. ',
				dir.CP) AS direcComplet
		INTO Var_numExtLetra,Var_numIntLetra,Var_DirecCliente1,Var_DirecCliente2,Var_DirecCliente
		FROM ESTADOSREPUB est
            INNER JOIN MUNICIPIOSREPUB mun ON mun.EstadoID=est.EstadoID
            INNER JOIN LOCALIDADREPUB loc ON loc.MunicipioID=mun.MunicipioID
										  AND loc.EstadoID=est.EstadoID
            INNER JOIN COLONIASREPUB col ON col.MunicipioID=mun.MunicipioID
										 AND col.EstadoID=est.EstadoID
            INNER JOIN DIRECCLIENTE dir ON dir.MunicipioID=mun.MunicipioID
										AND dir.ColoniaID=col.ColoniaID
										AND dir.LocalidadID=loc.LocalidadID
                                        AND dir.EstadoID=est.EstadoID
                                        AND dir.Oficial='S',
			INVERSIONES inv
		WHERE inv.ClienteID=dir.ClienteID
			AND inv.InversionID=Par_InversionID ORDER BY dir.DireccionID ASC LIMIT 1;


		SELECT cli.NombreCompleto
        INTO Var_NombreCte
		FROM CLIENTES cli,
			INVERSIONES inv
		WHERE inv.ClienteID=cli.ClienteID
		AND inv.InversionID=Par_InversionID;

        SELECT cinv.NumRegistroRECA
        INTO Var_numRECA
		FROM INVERSIONES inv,
			CATINVERSION cinv
		WHERE cinv.TipoInversionID=inv.TipoInversionID
		AND InversionID=Par_InversionID;

        SELECT CONCAT(mun.Nombre,', ',est.Nombre) AS ciudad,DATE_FORMAT(par.FechaSistema,'%d/%m/%Y') , FNFECHATEXTO(par.FechaSistema)
        INTO Var_DirecEmpresa,Var_NuevaFechaSis,Var_FechaSisLetra
		FROM ESTADOSREPUB AS est
			INNER JOIN MUNICIPIOSREPUB AS mun ON mun.EstadoID=est.EstadoID
			INNER JOIN COLONIASREPUB AS col ON col.MunicipioID=mun.MunicipioID,
			INSTITUCIONES inst,
			PARAMETROSSIS par,
			INVERSIONES inv
		WHERE  est.EstadoID=inst.EstadoEmpresa
		AND mun.MunicipioID=inst.MunicipioEmpresa
		AND col.ColoniaID=inst.ColoniaEmpresa
		AND par.InstitucionID=inst.InstitucionID
		AND par.EmpresaID=inv.EmpresaID
		AND inv.InversionID=Par_InversionID;

        -- Armado del encabezado del contrato para persona Fisica
        SET Var_LongLinea:=118; -- numero de caracteres por linea, incluyendo caracteres del codigo RTF
        SET Var_NumLineas:=4;	-- numero de renglones del parrafo
        SET Var_Encabezado:=CONCAT('{\\rtf1 Contrato de {\\b INVERSIÓN A PLAZO FIJO} que celebran por un parte FINANCIERA TAMAZULA S. A. DE C. V. S. F. P., a quien en lo',
							' sucesivo se denominará “LA SOCIEDAD”, representada en este acto por su representante legal, el LIC. {\\b ',Var_RepLegalEmpr,'}',
                            ' y por otra parte el C. {\\b ',Var_NombreCte,'}, ','en lo sucesivo "EL CLIENTE" de conformidad con las siguientes declaraciones y clausulas:'
							);
		-- NOTA: Al final de la cadena no debe ponerse la llave de cierre "}" ya que esta se agrega en pentaho
    END IF;
    -- fin consultas tamazula

    SELECT		IFNULL(Var_RepLegalEmpr,Cadena_Vacia) AS Var_RepLegalEmpr,		IFNULL(Var_TipoPer,Cadena_Vacia) AS Var_TipoPer,
				IFNULL(Var_EscPublica,Cadena_Vacia) AS Var_EscPublica,			IFNULL(Var_NumNotaria,Cadena_Vacia) AS Var_NumNotaria,
                IFNULL(Var_NombreNotario,Cadena_Vacia) AS Var_NombreNotario,	IFNULL(Var_DirecEscPub,Cadena_Vacia) AS Var_DirecEscPub,
                IFNULL(Var_DirecRegPub,Cadena_Vacia) AS Var_DirecRegPub,		IFNULL(Var_FechaEsc,Cadena_Vacia) AS Var_FechaEsc,
                IFNULL(Var_RazonSocial,Cadena_Vacia) AS Var_RazonSocial, 		IFNULL(Var_NombreCte,Cadena_Vacia) AS Var_NombreCte,
                IFNULL(Var_primerNom,Cadena_Vacia) AS Var_primerNom, 			IFNULL(Var_restoNomb,Cadena_Vacia) AS Var_restoNomb,
				IFNULL(Var_numRECA,Cadena_Vacia) AS Var_numRECA, 				IFNULL(Var_DirecEmpresa,Cadena_Vacia) AS Var_DirecEmpresa,
                IFNULL(Var_NuevaFechaSis,Cadena_Vacia) AS Var_NuevaFechaSis,	IFNULL(Var_FechaSisLetra,Cadena_Vacia) AS Var_FechaSisLetra,
                IFNULL(Var_numExtLetra,Cadena_Vacia) AS Var_numExtLetra, 		IFNULL(Var_numIntLetra,Cadena_Vacia) AS Var_numIntLetra,
				IFNULL(Var_DirecCliente1,Cadena_Vacia) AS Var_DirecCliente1, 	IFNULL(Var_DirecCliente2,Cadena_Vacia) AS Var_DirecCliente2,
                IFNULL(Var_DirecCliente,Cadena_Vacia) AS Var_DirecCliente, 		IFNULL(Var_FechaEscLetra,Cadena_Vacia) AS Var_FechaEscLetra,
                IFNULL(Var_FolioRegPub,Cadena_Vacia) AS Var_FolioRegPub,		IFNULL(Var_Encabezado,Cadena_Vacia) AS Var_Encabezado,
                Var_ContInversionID, Var_LongLinea,Var_NumLineas;
END IF;

END TerminaStore$$