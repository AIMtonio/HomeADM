-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PORTADACONTRATREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PORTADACONTRATREP`;DELIMITER $$

CREATE PROCEDURE `PORTADACONTRATREP`(
	Par_CuentaAhoID   		BIGINT(12),				-- Numero de Cuenta
	Par_NumCon      		TINYINT UNSIGNED,		-- Numero de Consulta

	Par_EmpresaID			INT(11),				-- Parametro de Auditoria
	Aud_Usuario				INT(11),				-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal			INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de Auditoria
    )
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE NumInstitucion      	  INT;
	DECLARE NomInstit         	  VARCHAR(100);
	DECLARE NomCortoInst      	  VARCHAR(45);
	DECLARE DirecInst       		  VARCHAR(250);
	DECLARE FechEsc         		  DATE;
	DECLARE TipoConstit       	  CHAR(1);
	DECLARE Var_ClienteID     	  INT;
	DECLARE Var_TipoCuenta      	  INT;
	DECLARE Var_Descripcion     	  VARCHAR(30);
	DECLARE Var_GeneraInt     	  CHAR(1);
	DECLARE Var_TipoInteres     	  CHAR(1);
	DECLARE Var_EsServicio      	  CHAR(1);
	DECLARE Var_EsBancaria      	  CHAR(1);
	DECLARE Var_MinimoApert     	  DECIMAL(12,2);
	DECLARE Var_ComApertura     	  DECIMAL(12,2);
	DECLARE Var_ComManeCta      	  DECIMAL(12,2);
	DECLARE Var_ComAnivers      	  DECIMAL(12,2);
	DECLARE Var_CobraBanEle     	  CHAR(1);
	DECLARE Var_CobraSpei    	 	  CHAR(1);
	DECLARE Var_ComFalsoCo      	  DECIMAL(12,2);
	DECLARE Var_ExPrDiaSeg      	  CHAR(1);
	DECLARE Var_ComDispSeg      	  DECIMAL(12,2);
	DECLARE Var_SalMinReq     	  DECIMAL(12,2);
	DECLARE Var_FechaApertura   	  DATE;
	DECLARE DirOficial          	  CHAR(1);
	DECLARE IdeOficial          	  CHAR(1);

	DECLARE	Var_Cliente         	  VARCHAR(50);
	DECLARE Var_CuentaAhoID         BIGINT(12);
	DECLARE Var_Abreviacion         VARCHAR(50);
	DECLARE Var_NombreCompleto      VARCHAR(200);
	DECLARE Var_Telefono            VARCHAR(50);
	DECLARE Var_Calle               VARCHAR(50);
	DECLARE Var_Colonia             VARCHAR(50);
	DECLARE Var_NombreLocalidad     VARCHAR(50);
	DECLARE Var_NumeroCasa          VARCHAR(50);
	DECLARE Var_NombreEstado        VARCHAR(50);
	DECLARE Var_CP                  VARCHAR(50);
	DECLARE Var_RFC                 VARCHAR(50);
	DECLARE Var_CURP                VARCHAR(50);
	DECLARE Var_NumIdentific        VARCHAR(50);
	DECLARE Var_ContPlazaID     	  VARCHAR(250);
	DECLARE Var_ContNombrePlaza     VARCHAR(250);
	DECLARE Var_Contrato        	  VARCHAR(250);
	DECLARE Var_AnioActual      	  CHAR(4);        -- anio actual
	DECLARE Var_MesActual    	 	  VARCHAR(15);    -- mes actual
	DECLARE Var_DiaActual     	  INT;      		-- dia actual
	DECLARE Var_InstitucionID       INT;            -- ID de la institucuion
	DECLARE Var_CiudadInstitu  	  VARCHAR(50);    -- cuidada de la institucion
	DECLARE Var_RepresentanteLegal VARCHAR(45); -- representante legaÃ±
	DECLARE Var_DirComp       	  VARCHAR(300);
	DECLARE Var_GatNominal      	  VARCHAR(300);
	DECLARE Var_GatReal       	  VARCHAR(300);
	DECLARE Var_tipoPer       	  VARCHAR(300);
	DECLARE Est_Soltero         	  CHAR(2);
	DECLARE Est_CasBieSep       	  CHAR(2);
	DECLARE Est_CasBieMan       	  CHAR(2);
	DECLARE Est_CasCapitu       	  CHAR(2);
	DECLARE Est_Viudo           	  CHAR(2);
	DECLARE Est_Divorciad       	  CHAR(2);
	DECLARE Est_Seperados       	  CHAR(2);
	DECLARE Est_UnionLibre      	  CHAR(2);

	-- Seccion FEMAZA para Datos de la Escritura
	DECLARE Var_NomLocRP              VARCHAR(150);
	DECLARE Var_EscrituraPublic       VARCHAR(50);
	DECLARE Var_VolumenEsc            VARCHAR(20);
	DECLARE Var_NomNotario            VARCHAR(100);
	DECLARE Var_Notaria               INT(11);
	DECLARE Var_NomLocEsc             VARCHAR(150);
	DECLARE Var_NomEstEsc             VARCHAR(100);
	DECLARE Var_NotDireccion          VARCHAR(240);
	DECLARE Var_TxtNotaria1           VARCHAR(350);
	DECLARE Var_TxtEscritura          VARCHAR(200);
	DECLARE Var_DomSucursal           VARCHAR(250);
	DECLARE Con_PortadaConFEM     	  INT;
	DECLARE Con_PortadaFinSoc         INT;
	DECLARE Con_SolicitudFinSoc       INT;
	DECLARE Con_BeneficiCuenta        INT;
	DECLARE Var_TasaRend              DECIMAL(12,4);
	DECLARE VarClienteMe              CHAR(1);
	DECLARE Var_Tasa                  DECIMAL(10,4);
	DECLARE Var_TipCtaDescrip         VARCHAR(50);
	DECLARE Var_TipoCta               INT(2);
    DECLARE Var_SoloNumeros			  INT(11);
	-- Fin Social

	DECLARE Var_ClienteIdFiSoc         BIGINT(11);
	DECLARE Var_NomComplCliFiSoc       VARCHAR(200);
	DECLARE Var_GatInforFiSoc    	   DECIMAL(12,2);
	DECLARE Var_NombreCortInstFiSoc    VARCHAR(45);
	DECLARE Var_DirecionInstFiSoc      VARCHAR(250);
	DECLARE Var_TelefonoFiSoc          VARCHAR(20);
	DECLARE Var_NomRepreFiSoc          VARCHAR(100);
	DECLARE Var_TasInteresFiSoc        DECIMAL(12,2);
	DECLARE Var_MontoMiniFiSoc         DECIMAL(12,2);
	DECLARE Var_ClienteIDCFinS         VARCHAR(12);
	DECLARE Var_CuentaCFinS            VARCHAR(12);
	DECLARE Var_RECACFinSoc            VARCHAR(100);
	DECLARE Var_NombresCliFinS         VARCHAR(100);
	DECLARE Var_ApellCliPFinS          VARCHAR(100);
	DECLARE Var_ApellCliMFinS          VARCHAR(100);
	DECLARE Var_EstadoCivilFinS        VARCHAR(100);
	DECLARE Var_DesProductoFinS        VARCHAR(200);
	DECLARE Var_CliCURPFinS            VARCHAR(20);
	DECLARE Var_CliRFCFinS        	   VARCHAR(20);
	DECLARE Var_CliNacionFinS          VARCHAR(50);
	DECLARE Var_CliGeneroFinS          VARCHAR(20);
	DECLARE Var_CliCorreoFinS          VARCHAR(60);
	DECLARE Var_OcupacionFinS          VARCHAR(1000);
	DECLARE Var_FechNFinS        	   DATE;
	DECLARE Var_EmplFormFinS      	   CHAR(1);
	DECLARE Var_CliTelCasaFinS         VARCHAR(20);
	DECLARE Var_CliTelCelFinS          VARCHAR(30);
	DECLARE Var_PEPsFinS        	   CHAR(1);
	DECLARE Var_DesPuesTPEPFinS        VARCHAR(150);
	DECLARE Var_ParentPEPSFinS     	   CHAR(1);
	DECLARE Var_LugarTrabjFinS         VARCHAR(100);
	DECLARE Var_CliCalleFinS           VARCHAR(200);
	DECLARE Var_CliNumCasaFinS         VARCHAR(20);
	DECLARE Var_CliColoniFinS          VARCHAR(400);
	DECLARE Var_CliColMunFinS          VARCHAR(300);
	DECLARE Var_CliEstadoFinS          VARCHAR(200);
	DECLARE Var_CliCPFinS              CHAR(10);
	DECLARE Var_CliNumIntFinS          VARCHAR(20);
	DECLARE Var_CliCiudadFinS          VARCHAR(100);
	DECLARE Var_TipoVivIIDFinS         INT;
	DECLARE Var_TiemHabiDomFinS        INT;
	DECLARE Var_MesesFinS       	   INT(11);
	DECLARE Var_AniosFinS       	   INT(11);
	DECLARE Var_DescCtaFinSoc     	   VARCHAR(30);
	DECLARE Var_NivelCtaFinSoc         INT(11);
	DECLARE Var_TipoPersoFiSoc         CHAR(1);
	DECLARE Var_RecursoPFinSoc         CHAR(1);
	DECLARE Var_FecApCtaFinSoc         DATE;
	DECLARE Var_DirSucurFinSoc         VARCHAR(250);
	DECLARE Var_NomPromoFinSoc         VARCHAR(100);
	DECLARE Var_FecConBuFinSoc         DATE;
	DECLARE Var_FolConBuFinSoc         VARCHAR(30);
	DECLARE Var_FolCoBuCFinSoc         VARCHAR(30);
	DECLARE Var_PromotorFinS           INT(6);
	DECLARE Var_IDConsulFinSoc         VARCHAR(20);
	DECLARE Var_ConseFirmaCFinS        INT(11);
	DECLARE Var_RecurFirmCFinS         VARCHAR(100);
	DECLARE Var_FechaCtaLetFinS        VARCHAR(70);
	DECLARE Var_NumIdenFinS            VARCHAR(45);
	DECLARE Var_TipoIdenFinS           VARCHAR(30);
	DECLARE Nac_Mexicano               CHAR(1);
	DECLARE Var_ProprFinS              VARCHAR(200);
	DECLARE Var_RFCRFinS               CHAR(13);
	DECLARE Var_DireccionRFinS         VARCHAR(20);
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia      	CHAR(1);
	DECLARE Fecha_Vacia       	DATE;
	DECLARE Entero_Cero       	INT;
	DECLARE Con_PortadaCon      	INT;
	DECLARE Con_PortadaConTR   	INT;
	DECLARE Con_RepCOOPE          INT;
	DECLARE Con_SofiExpress    	INT;
	DECLARE Var_SI          		CHAR(1);
	DECLARE Var_NO         		CHAR(1);

	DECLARE mes1          CHAR(1);
	DECLARE mes2          CHAR(1);
	DECLARE mes3          CHAR(1);
	DECLARE mes4          CHAR(1);
	DECLARE mes5          CHAR(1);
	DECLARE mes6          CHAR(1);
	DECLARE mes7          CHAR(1);
	DECLARE mes8          CHAR(1);
	DECLARE mes9          CHAR(1);
	DECLARE mes10         CHAR(2);
	DECLARE mes11         CHAR(2);
	DECLARE mes12         CHAR(2);

	/* Accion y evlolucion Con_Accionyevol */
	DECLARE Con_AccionyEvol       INT;
	DECLARE TipCuenta_Desc      	VARCHAR(30); -- la descripcion de el tipo de cuenta
	DECLARE Cuenta_TasaInteres    VARCHAR(30);
	DECLARE Cli_RazonSoc      	VARCHAR(150);
	DECLARE Cli_SMTutor       	INT; -- tutor del socio menor
	DECLARE Cli_SMTutorNom      	VARCHAR(300);
	DECLARE Sis_FechaActual     	VARCHAR(100);
	/*Constantes fin social*/
	DECLARE SiBeneficiario      CHAR(1);
	DECLARE RecursosPropios     CHAR(1);
	DECLARE RecursosTerceros    CHAR(1);
	DECLARE NNacional         	VARCHAR(11);
	DECLARE NExtranjero         VARCHAR(11);
	DECLARE TxtEnero        	VARCHAR(20);
	DECLARE TxtFebrero        	VARCHAR(20);
	DECLARE TxtMarzo        	VARCHAR(20);
	DECLARE TxtAbril       	 	VARCHAR(20);
	DECLARE TxtMayo         	VARCHAR(20);
	DECLARE TxtJunio        	VARCHAR(20);
	DECLARE TxtJulio         	VARCHAR(20);
	DECLARE TxtAgosto         	VARCHAR(20);
	DECLARE TxtSeptiembre     	VARCHAR(20);
	DECLARE TxtOctubre        	VARCHAR(20);
	DECLARE TxtNoviembre      	VARCHAR(20);
	DECLARE TxtDiciembre      	VARCHAR(20);

	DECLARE Des_Soltero         CHAR(50);
	DECLARE Des_CasBieSep       CHAR(50);
	DECLARE Des_CasBieMan       CHAR(50);
	DECLARE Des_CasCapitu       CHAR(50);
	DECLARE Des_Viudo           CHAR(50);
	DECLARE Des_Divorciad       CHAR(50);
	DECLARE Des_Seperados       CHAR(50);
	DECLARE Des_UnionLibre      CHAR(50);
	-- Asignacion de Constantes
	SET Cadena_Vacia        := '';
	SET Fecha_Vacia         := '1900-01-01';
	SET Entero_Cero         := 0;
	SET Con_PortadaCon      := 1;
	SET Con_PortadaConTR    := 2;     -- Portada Contrato de Cuentas Tres Reyes
	SET Con_RepCOOPE        := 3;
	SET Con_SofiExpress     := 4;     -- Caratula de contrato de Sofiexpress(OrderExpress)
	SET Con_AccionyEvol     := 5;     -- Caratula de contrato de Accion y Evolucion
	SET Con_PortadaConFEM   := 6;     -- Caratula de contrato para FEMAZA
	SET Con_PortadaFinSoc   := 7;     -- Caratula de contrato para fin social
	SET Con_SolicitudFinSoc := 8;   -- Solicitu de cueta fin social
	SET Con_BeneficiCuenta  := 9;     -- beneficiarios de cuenta finsocial
	SET TipoConstit         := 'C';
	SET DirOficial          := 'S';
	SET IdeOficial          := 'S';
	SET Var_SI        		:= 'S';
	SET Var_NO        		:= 'N';
	SET Nac_Mexicano    	:= 'N';
	SET NNacional     		:= 'Nacional';
	SET NExtranjero    		:= 'Extranjero';
	SET SiBeneficiario    	:= 'S';
	SET RecursosPropios  	:= 'P';
	SET RecursosTerceros  	:= 'N';
	SET Est_Soltero       	:= 'S';        -- Estado Civil Soltero
	SET Est_CasBieSep     	:= 'CS';       -- Casado Bienes Separados
	SET Est_CasBieMan     	:= 'CM';       -- Casado Bienes Mancomunados
	SET Est_CasCapitu     	:= 'CC';       -- Casado Bienes Mancomunados Con Capitulacion
	SET Est_Viudo         	:= 'V';        -- Viudo
	SET Est_Divorciad     	:= 'D';        -- Divorciado
	SET Est_Seperados     	:='SE';        -- Separado
	SET Est_UnionLibre    	:= 'U';        -- Union Libre
	SET Des_Soltero       	:= 'SOLTERO(A)';                    -- Descripcion para el estado civil de un cliente
	SET Des_CasBieSep     	:= 'CASADO(A) BIENES SEPARADOS';            -- Descripcion para el estado civil de un cliente
	SET Des_CasBieMan     	:= 'CASADO(A) BIENES MANCOMUNADOS';           -- Descripcion para el estado civil de un cliente
	SET Des_CasCapitu     	:= 'CASADO(A) BIENES MANCOMUNADOS CON CAPITULACION';  -- Descripcion para el estado civil de un cliente
	SET Des_Viudo         	:= 'VIUDO(A)';                      -- Descripcion para el estado civil de un cliente
	SET Des_Divorciad     	:= 'DIVORCIADO(A)';                   -- Descripcion para el estado civil de un cliente
	SET Des_Seperados     	:= 'SEPARADO(A)';                   -- Descripcion para el estado civil de un cliente
	SET Des_UnionLibre   	:= 'UNION LIBRE';                   -- Descripcion para el estado civil de un cliente
	SET mes1        		:= 1; -- correspondiente a enero
	SET mes2        		:= 2; -- correspondiente a febrero
	SET mes3        		:= 3; -- correspondiente a marzo
	SET mes4        		:= 4; -- correspondiente a abril
	SET mes5       			:= 5; -- correspondiente a mayo
	SET mes6        		:= 6; -- correspondiente a junio
	SET mes7        		:= 7; -- correspondiente a julio
	SET mes8        		:= 8; -- correspondiente a agosto
	SET mes9        		:= 9; -- correspondiente a septiembre
	SET mes10       		:= 10; -- correspondiente a octubre
	SET mes11       		:= 11; -- correspondiente a noviembre
	SET mes12       		:= 12; -- correspondiente a diciembre
	SET TxtEnero      		:= 'Enero';
	SET TxtFebrero      	:= 'Febrero';
	SET TxtMarzo      		:= 'Marzo';
	SET TxtAbril      		:= 'Abril';
	SET TxtMayo       		:= 'Mayo';
	SET TxtJunio      		:= 'Junio';
	SET TxtJulio      		:= 'Julio';
	SET TxtAgosto       	:= 'Agosto';
	SET TxtSeptiembre     	:= 'Septiembre';
	SET TxtOctubre      	:= 'Octubre';
	SET TxtNoviembre    	:= 'Noviembre';
	SET TxtDiciembre    	:= 'Diciembre';

	/* comunes para todos los contratos */
	  SELECT
		ps.InstitucionID, ps.NombreRepresentante, ins.Nombre, ins.DirFiscal,  FORMATEAFECHACONTRATO(ps.FechaSistema)
		INTO
		Var_InstitucionID, Var_RepresentanteLegal, NomInstit, DirecInst,    Sis_FechaActual
		FROM
		PARAMETROSSIS ps
		LEFT OUTER JOIN INSTITUCIONES ins ON ps.InstitucionID = ins.InstitucionID
	  WHERE ps.EmpresaID = Par_EmpresaID;

	IF(Par_NumCon = Con_PortadaCon) THEN


	  SET NumInstitucion := (SELECT InstitucionID FROM PARAMETROSSIS);

	  SELECT  Nombre,   NombreCorto,    Direccion
		  INTO
		  NomInstit,  NomCortoInst,   DirecInst
		FROM INSTITUCIONES
		WHERE InstitucionID = NumInstitucion;

	  SELECT  ClienteID,    TipoCuentaID
		  INTO
		  Var_ClienteID,  Var_TipoCuenta
		FROM CUENTASAHO
		WHERE CuentaAhoID = Par_CuentaAhoID;

	  SET FechEsc :=(SELECT FechaEsc
			  FROM ESCRITURAPUB
			  WHERE ClienteID = Var_ClienteID
			  AND Esc_Tipo = TipoConstit);


	  SELECT  Descripcion,    GeneraInteres,  TipoInteres,    EsServicio,     EsBancaria,
		  MinimoApertura,   ComApertura,  ComManejoCta,   ComAniversario,   CobraBanEle,
		  CobraSpei,        ComFalsoCobro,  ExPrimDispSeg,    ComDispSeg,       SaldoMinReq
		  INTO
		  Var_Descripcion,  Var_GeneraInt,    Var_TipoInteres,  Var_EsServicio, Var_EsBancaria,
		  Var_MinimoApert,  Var_ComApertura,  Var_ComManeCta,   Var_ComAnivers, Var_CobraBanEle,
		  Var_CobraSpei,    Var_ComFalsoCo,   Var_ExPrDiaSeg,   Var_ComDispSeg, Var_SalMinReq
		FROM TIPOSCUENTAS
		WHERE TipoCuentaID = Var_TipoCuenta;


	  SELECT  Var_Descripcion,  Var_GeneraInt,    Var_TipoInteres,  Var_EsServicio, Var_EsBancaria,
		  Var_MinimoApert,  Var_ComApertura,  Var_ComManeCta,   Var_ComAnivers, Var_CobraBanEle,
		  Var_CobraSpei,    Var_ComFalsoCo,   Var_ExPrDiaSeg,   Var_ComDispSeg, Var_SalMinReq ,
		  NomInstit,      NomCortoInst,     DirecInst,      FechEsc;

	END IF;

	IF(Par_NumCon = Con_PortadaConTR) THEN
	SELECT LPAD(CONVERT(Aho.CuentaAhoID, CHAR),10,0) AS CuentaAhoID,Tip.Abreviacion,
		 LPAD(CONVERT(Cli.ClienteID, CHAR),10,0) AS ClienteID,Cli.NombreCompleto,Cli.Telefono,
		 Dir.Calle, Dir.Colonia,Loc.NombreLocalidad,Dir.NumeroCasa,Est.Nombre,
		 Dir.CP,Cli.RFC,Cli.CURP,Ide.Descripcion,Ide.NumIdentific
	  INTO Var_CuentaAhoID, Var_Abreviacion, Var_Cliente, Var_NombreCompleto,
		Var_Telefono,    Var_Calle,       Var_Colonia, Var_NombreLocalidad,
		Var_NumeroCasa,  Var_NombreEstado, Var_CP,     Var_RFC,
		Var_CURP,       Var_Descripcion,   Var_NumIdentific
	  FROM CUENTASAHO Aho
		INNER  JOIN TIPOSCUENTAS Tip ON Tip.TipoCuentaID=Aho.TipoCuentaID
		INNER  JOIN CLIENTES Cli ON Aho.ClienteID=Cli.ClienteID
		INNER  JOIN DIRECCLIENTE Dir ON Dir.ClienteID=Cli.ClienteID AND Dir.Oficial=DirOficial
		INNER  JOIN ESTADOSREPUB Est ON Est.EstadoID=Dir.EstadoID
		LEFT JOIN MUNICIPIOSREPUB Mun ON Dir.MunicipioID = Mun.MunicipioID  AND Mun.EstadoID=Dir.EstadoID
		LEFT JOIN LOCALIDADREPUB Loc ON Dir.MunicipioID = Loc.MunicipioID
							  AND Loc.EstadoID=Dir.EstadoID
							  AND Dir.LocalidadID=Loc.LocalidadID
		LEFT JOIN IDENTIFICLIENTE Ide ON Ide.ClienteID=Cli.ClienteID AND Ide.Oficial=IdeOficial
		WHERE Aho.CuentaAhoID = Par_CuentaAhoID
		LIMIT 1;

		SELECT Pla.PlazaID,
		  CASE Pla.Nombre
		  WHEN "Oaxaca Centro" THEN "OAXACA"
		  END AS NombrePlaza
		INTO Var_ContPlazaID, Var_ContNombrePlaza
		  FROM SUCURSALES Suc
			   INNER  JOIN PLAZAS Pla ON Suc.Sucursal = Pla.Sucursal
		  WHERE Pla.Sucursal = Aud_Sucursal
		  LIMIT 1;

		SELECT COUNT(CuentaAhoID)+1
		  INTO Var_Contrato
		 FROM CUENTASAHO;

	  SELECT Var_CuentaAhoID,   Var_Abreviacion,  Var_Cliente,  Var_NombreCompleto,
		Var_Telefono,     Var_Calle,      Var_Colonia,  Var_NombreLocalidad,
		Var_NumeroCasa,   Var_NombreEstado,   Var_CP,     Var_RFC,
		Var_CURP,       Var_Descripcion,  Var_NumIdentific,Var_ContPlazaID,
		Var_ContNombrePlaza,Var_Contrato;
	  END IF;


	-- REPORTE PERZONALIZADO PARA LACOOPE

	IF(Par_NumCon = Con_RepCOOPE) THEN

	  SELECT  InstitucionID, NombreRepresentante
		 INTO Var_InstitucionID, Var_RepresentanteLegal
		 FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;

		SELECT mun.Nombre
		  INTO Var_CiudadInstitu
		  FROM INSTITUCIONES AS inst
		   LEFT JOIN MUNICIPIOSREPUB AS mun ON inst.MunicipioEmpresa  = mun.MunicipioID
		 LEFT JOIN ESTADOSREPUB AS est ON mun.EstadoID = est.EstadoID
			   WHERE inst.InstitucionID = Var_InstitucionID
				 AND mun.MunicipioID =  inst.MunicipioEmpresa
		   AND est.EstadoID  = inst.EstadoEmpresa;

	  SELECT  YEAR(FechaActual),
	CASE MONTH(FechaActual)   WHEN  mes1  THEN  TxtEnero
				  WHEN  mes2  THEN  TxtFebrero
				  WHEN  mes3  THEN  TxtMarzo
				  WHEN  mes4  THEN  TxtAbril
				  WHEN  mes5  THEN  TxtMayo
				  WHEN  mes6  THEN  TxtJunio
				  WHEN  mes7  THEN  TxtJulio
				  WHEN  mes8  THEN  TxtAgosto
				  WHEN  mes9  THEN  TxtSeptiembre
				  WHEN  mes10 THEN  TxtOctubre
				  WHEN  mes11 THEN  TxtNoviembre
				  WHEN  mes12 THEN  TxtDiciembre
							ELSE '---'  END,
	 DAY(FechaActual)
		 INTO Var_AnioActual, Var_MesActual, Var_DiaActual
		 FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;


	SELECT   LPAD(CONVERT(Cli.ClienteID, CHAR),10,0) AS ClienteID,  CONCAT(Cli.PrimerNombre,' ', Cli.SegundoNombre,' ', Cli.TercerNombre,' ', Cli.ApellidoPaterno,' ',Cli.ApellidoMaterno)
		INTO  Var_Cliente,   Var_NombreCompleto
		FROM CUENTASAHO Aho
		INNER  JOIN CLIENTES Cli ON Aho.ClienteID=Cli.ClienteID
		WHERE CuentaAhoID = Par_CuentaAhoID;

	SELECT Var_Cliente,     Var_NombreCompleto,   Var_AnioActual,   Var_MesActual,  Var_DiaActual,
		Var_CiudadInstitu,  Var_RepresentanteLegal;

	END IF;
	IF(Par_NumCon = Con_SofiExpress) THEN

	  SELECT ClienteID, FechaApertura
		INTO Var_Cliente, Var_FechaApertura
		  FROM CUENTASAHO
			WHERE CuentaAhoID = Par_CuentaAhoID;
	  SET Var_AnioActual := YEAR(Var_FechaApertura);
		SET Var_MesActual :=
		  CASE MONTH(Var_FechaApertura) WHEN mes1 THEN TxtEnero
				WHEN mes2 THEN TxtFebrero
				WHEN mes3 THEN TxtMarzo
				WHEN mes4 THEN TxtAbril
				WHEN mes5 THEN TxtMayo
				WHEN mes6 THEN TxtJunio
				WHEN mes7 THEN TxtJulio
				WHEN mes8 THEN TxtAgosto
				WHEN mes9 THEN TxtSeptiembre
				WHEN mes10 THEN TxtOctubre
				WHEN mes11 THEN	TxtNoviembre
							WHEN mes12 THEN TxtDiciembre
							ELSE '---'  END;
		SET Var_DiaActual := DAY(Var_FechaApertura);

	  SELECT  NombreCompleto , RFCOficial
		INTO  Var_NombreCompleto , Var_RFC
		  FROM CLIENTES
			WHERE ClienteID = Var_Cliente;

	  SELECT DireccionCompleta
		INTO Var_DirComp
		  FROM DIRECCLIENTE
			WHERE Oficial = DirOficial
			  AND ClienteID = Var_Cliente;


	  SELECT  us.NombreCompleto , CONCAT(IF(mr.Nombre = NULL, '', CONCAT(mr.Nombre,',') ), IFNULL(er.Nombre,'' ))
		INTO  Var_RepresentanteLegal, DirecInst
		  FROM  SUCURSALES sc
			LEFT OUTER JOIN USUARIOS us ON sc.NombreGerente = us.UsuarioID
			LEFT OUTER JOIN ESTADOSREPUB er ON sc.EstadoID = er.EstadoID
			LEFT OUTER JOIN MUNICIPIOSREPUB mr  ON  sc.EstadoID = mr.EstadoID
							  AND sc.MunicipioID = mr.MunicipioID
			WHERE sc.SucursalID = Aud_Sucursal LIMIT 1;

	  SET Aud_FechaActual = (SELECT FechaActual FROM PARAMETROSSIS LIMIT 1);

	  SELECT  ca.CuentaAhoID,
		  tc.Descripcion AS NombreComercial,
				'Deposito' AS TipoOperacion,
		  CASE
			WHEN GeneraInteres = 'S' THEN
			  CONCAT('Tasa Fija ', ta.Tasa, '%')
			ELSE 'Sin Interes'
		  END AS TipoTasa,

				CONCAT(IFNULL(ca.Gat,'0.00'),'%') AS GatNominal,
				CONCAT(IFNULL(ca.GatReal, '0.00'),'%') AS GatReal,
		  tc.ComApertura,
		  IFNULL(IF( cl.TipoPersona = 'M', tc.ComSpeiPerMor,tc.ComSpeiPerFis ),0.00)AS ComTransfFondos,
		  ca.EstadoCta,

				Var_NombreCompleto,
		  tc.NumRegistroRECA AS RECA,
		  Var_RepresentanteLegal AS Var_RepresentanteLegal,
		  IFNULL(IF( cl.TipoPersona = 'M',cl.RazonSocial,  cl.NombreCompleto),'') AS NombreCliente,
		  Var_RFC,  Var_DirComp, DirecInst, DATE(Aud_FechaActual) AS FechaActual,
		  CONCAT(Var_DiaActual,' de ', Var_MesActual,' de ', Var_AnioActual) AS Var_FechaApertura
		FROM
		  CUENTASAHO ca LEFT OUTER JOIN TASASAHORRO ta ON ca.TipoCuentaID = ta.TipoCuentaID,
		  TIPOSCUENTAS tc,
		  CLIENTES cl
		  WHERE   ca.TipoCuentaID = tc.TipoCuentaID
			AND   ca.CLienteID = cl.ClienteID
			AND   CuentaAhoID = Par_CuentaAhoID LIMIT 1;
	END IF;

	IF(Par_NumCon = Con_AccionyEvol)THEN

	  SET Var_Cliente = (SELECT ClienteID
				  FROM CUENTASAHO
					WHERE CuentaAhoID = Par_CuentaAhoID);
	  SELECT  NombreCompleto ,    RFCOficial,   TipoPersona,  RazonSocial
		INTO  Var_NombreCompleto ,  Var_RFC,    Var_tipoPer,  Cli_RazonSoc
		  FROM CLIENTES
			WHERE ClienteID = Var_Cliente;

	  SELECT  tc.Descripcion, IFNULL(CONCAT(ta.Tasa,'%'),'0.00%'),  IFNULL(CONCAT(tc.GatInformativo,'%'),'0.00%')
		INTO  TipCuenta_Desc, Cuenta_TasaInteres,           Var_GatNominal
		  FROM  CUENTASAHO ca
			LEFT OUTER JOIN TIPOSCUENTAS tc ON ca.TipoCuentaID = tc.TipoCuentaID
			LEFT OUTER JOIN TASASAHORRO ta  ON ca.TipoCuentaID = ta.TipoCuentaID
							AND ta.MonedaID = 1
							AND ta.TipoPersona = Var_tipoPer
			WHERE ca.CuentaAhoID = Par_CuentaAhoID
			  LIMIT 1;

	  SET Cli_SMTutor := IFNULL((
					SELECT ClienteTutorID
					  FROM SOCIOMENOR
						WHERE SocioMenorID = Var_Cliente), 0);
	  IF Cli_SMTutor != 0 THEN
		SELECT  pa.NombreCompleto
		  INTO  Cli_SMTutorNom
			FROM
			  SOCIOMENOR sm LEFT OUTER JOIN
						CLIENTES pa ON pa.ClienteID = sm.ClienteTutorID
			WHERE
			  sm.SocioMenorID = Var_Cliente;
	  ELSE
		SELECT  sm.NombreTutor
		  INTO  Cli_SMTutorNom
			FROM
			SOCIOMENOR sm
			  WHERE sm.SocioMenorID = Var_Cliente;
	  END IF;


	  SELECT
		Var_Cliente,    Var_tipoPer,        Var_NombreCompleto,   Var_RFC,  TipCuenta_Desc,
		Cuenta_TasaInteres, Var_GatNominal,     NomInstit,        DirecInst,  Var_RepresentanteLegal,
		Cli_RazonSoc,     Cli_SMTutorNom,     Sis_FechaActual;

	END IF;


	-- REPORTE PARA FEMAZA
	IF(Par_NumCon = Con_PortadaConFEM) THEN
		-- SECCION PARA OBTENER DATOS DE LA ESCRITURA
		-- REGISTRO PUBLICO
		SELECT MPIOSRPP.Nombre AS NomLocRP
		INTO Var_NomLocRP
		  FROM ESCRITURAPUB AS RPP
			INNER  JOIN MUNICIPIOSREPUB AS MPIOSRPP ON (MPIOSRPP.MunicipioID = RPP.LocalidadRegPub AND MPIOSRPP.EstadoID = RPP.EstadoIDReg)
		WHERE RPP.EmpresaID = Par_EmpresaID
			AND RPP.Esc_Tipo = TipoConstit
            AND RPP.ClienteID=1 LIMIT 1;

		-- NOTARIA
		SELECT ESC.EscrituraPublic, ESC.VolumenEsc, ESC.Notaria, MPIOSESC.Nombre AS NomLocEsc,
			EDOESC.Nombre AS NomEstEsc, DES.Titular AS NomNotario, DES.Direccion
	   INTO Var_EscrituraPublic, Var_VolumenEsc, Var_Notaria, Var_NomLocEsc,
			Var_NomEstEsc, Var_NomNotario, Var_NotDireccion
		FROM ESCRITURAPUB AS ESC
			INNER  JOIN MUNICIPIOSREPUB AS MPIOSESC ON (MPIOSESC.MunicipioID = ESC.LocalidadEsc AND MPIOSESC.EstadoID = ESC.EstadoIDReg)
			INNER  JOIN ESTADOSREPUB AS EDOESC ON (EDOESC.EstadoID = ESC.EstadoIDEsc)
			INNER  JOIN NOTARIAS AS DES ON DES.NotariaID = ESC.Notaria
		WHERE ESC.EmpresaID = Par_EmpresaID
			AND ESC.Esc_Tipo = TipoConstit
            AND ESC.ClienteID=1 LIMIT 1;

		SELECT DirecCompleta
		INTO Var_DomSucursal
		  FROM SUCURSALES
			WHERE SucursalID = Aud_Sucursal;
		SET Var_TxtNotaria1 := UPPER(CONCAT(Var_NomLocEsc,', ',Var_NotDireccion,'. ',Var_NomEstEsc));

        SET Var_SoloNumeros := Var_EscrituraPublic REGEXP '^[0-9]';

        IF(Var_SoloNumeros = Entero_Cero) THEN
			SET Var_TxtEscritura := Var_EscrituraPublic;
		ELSE
		SET Var_TxtEscritura := CONCAT(CONVERT(Var_EscrituraPublic, CHAR),' (', TRIM(FUNCIONNUMEROSLETRAS(Var_EscrituraPublic)),')');
		END IF;
        -- TERMINA SECCION PARA OBTENER DATOS DE LA ESCRITURA

		-- OBTENCION TASA AHORRO
		-- SELECT CTAAHO.CuentaAhoID, CTAAHO.TipoCuentaID, TASAAHO.Tasa
		SELECT TASAAHO.Tasa
		INTO Var_TasaRend
		  FROM CUENTASAHO AS CTAAHO
			INNER  JOIN TASASAHORRO AS TASAAHO ON TASAAHO.TipoCuentaID = CTAAHO.TipoCuentaID
			INNER  JOIN CLIENTES CLI ON CTAAHO.ClienteID = CLI.ClienteID
			  WHERE CTAAHO.CuentaAhoID = Par_CuentaAhoID
				AND CTAAHO.Saldo BETWEEN TASAAHO.MontoInferior
							AND TASAAHO.MontoSuperior
				AND CLI.TipoPersona = TASAAHO.TipoPersona;

		SET Var_TasaRend :=  IFNULL(Var_TasaRend,0.00);

	  SELECT EsMenorEdad
		INTO VarClienteMe
		  FROM CUENTASAHO Cue
			INNER  JOIN CLIENTES Cli
			  ON Cue.ClienteID = Cli.ClienteID
			  WHERE Cue.CuentaAhoID =Par_CuentaAhoID;
		IF(VarClienteMe  ='N') THEN
			SELECT  LPAD(CONVERT(Aho.CuentaAhoID, CHAR),10,0) AS CuentaAhoID,
			Tip.Abreviacion,
			LPAD(CONVERT(Cli.ClienteID, CHAR),10,0) AS ClienteID,
					Cli.NombreCompleto,
					Cli.Telefono,

			Dir.Calle,  Dir.Colonia,  Loc.NombreLocalidad,  Dir.NumeroCasa,   Est.Nombre,
			Dir.CP,       Cli.RFC,    Cli.CURP,       Ide.Descripcion,  Ide.NumIdentific,
					Tip.Descripcion,  Aho.TipoCuentaID
			INTO  Var_CuentaAhoID,
			Var_Abreviacion,
					Var_Cliente,
					Var_NombreCompleto,
			Var_Telefono,

					Var_Calle,      Var_Colonia,  Var_NombreLocalidad,   Var_NumeroCasa,   Var_NombreEstado,
					Var_CP,         Var_RFC,    Var_CURP,        Var_Descripcion,    Var_NumIdentific,
					Var_TipCtaDescrip,  Var_TipoCta
			FROM CUENTASAHO Aho
			INNER  JOIN TIPOSCUENTAS Tip ON Tip.TipoCuentaID=Aho.TipoCuentaID
			INNER  JOIN CLIENTES Cli ON Aho.ClienteID=Cli.ClienteID
			INNER  JOIN DIRECCLIENTE Dir ON Dir.ClienteID=Cli.ClienteID AND Dir.Oficial=DirOficial
			INNER  JOIN ESTADOSREPUB Est ON Est.EstadoID=Dir.EstadoID
			LEFT JOIN MUNICIPIOSREPUB Mun ON Dir.MunicipioID = Mun.MunicipioID  AND Mun.EstadoID=Dir.EstadoID
			LEFT JOIN LOCALIDADREPUB Loc ON Dir.MunicipioID = Loc.MunicipioID
			  AND Loc.EstadoID=Dir.EstadoID
			  AND Dir.LocalidadID=Loc.LocalidadID
			LEFT JOIN IDENTIFICLIENTE Ide ON Ide.ClienteID=Cli.ClienteID AND Ide.Oficial=IdeOficial
		  WHERE Aho.CuentaAhoID = Par_CuentaAhoID
			LIMIT 1;

			SELECT Pla.PlazaID,
				CASE Pla.Nombre
			WHEN "Oaxaca Centro" THEN "OAXACA"
			END AS NombrePlaza
			INTO Var_ContPlazaID, Var_ContNombrePlaza
			FROM SUCURSALES Suc
				INNER  JOIN PLAZAS Pla ON Suc.Sucursal = Pla.Sucursal
			WHERE Pla.Sucursal = Aud_Sucursal
			LIMIT 1;

			SELECT COUNT(CuentaAhoID)+1
			INTO Var_Contrato
			FROM CUENTASAHO;

			SET Var_TipCtaDescrip:=REPLACE(Var_TipCtaDescrip,'CUENTAS',Cadena_Vacia);
			SET Var_TipCtaDescrip:=REPLACE(Var_TipCtaDescrip,'CUENTA',Cadena_Vacia);
			SET Var_TipCtaDescrip:=REPLACE(Var_TipCtaDescrip,'DE ',Cadena_Vacia);

			SELECT Var_CuentaAhoID,   Var_Abreviacion,  Var_Cliente,    Var_NombreCompleto,
		  Var_Telefono,     Var_Calle,      Var_Colonia,    Var_NombreLocalidad,
		  Var_NumeroCasa,   Var_NombreEstado,   Var_CP,       Var_RFC,
		  Var_CURP,       Var_Descripcion,  Var_NumIdentific, Var_ContPlazaID,
		  Var_ContNombrePlaza,Var_Contrato, Var_TipCtaDescrip, Var_TipoCta, FechEsc,
				Var_NomLocRP, Var_EscrituraPublic, Var_VolumenEsc, Var_Notaria, Var_NomNotario,
				Var_TxtEscritura, Var_TxtNotaria1, ROUND(Var_TasaRend,2) AS Var_TasaRend, Var_DomSucursal;  -- round(Var_Tasa,2) AS Var_Tasa,

		ELSE
			SET NumInstitucion := (SELECT InstitucionID FROM PARAMETROSSIS);
			SELECT  Nombre,   NombreCorto,    Direccion
		  INTO NomInstit, NomCortoInst,   DirecInst
			FROM INSTITUCIONES
			  WHERE InstitucionID = NumInstitucion;

			SELECT  ClienteID,    TipoCuentaID
		  INTO Var_ClienteID, Var_TipoCuenta
			FROM CUENTASAHO
			  WHERE CuentaAhoID = Par_CuentaAhoID;

			SET FechEsc :=(SELECT FechaEsc
										FROM ESCRITURAPUB
										WHERE ClienteID = Var_ClienteID
											AND Esc_Tipo = TipoConstit);

			SELECT  Descripcion,    GeneraInteres,  TipoInteres,    EsServicio,   EsBancaria,
			MinimoApertura,   ComApertura,    ComManejoCta,   ComAniversario,   CobraBanEle,
			CobraSpei,      ComFalsoCobro,  ExPrimDispSeg,  ComDispSeg,       SaldoMinReq
		  INTO  Var_Descripcion,  Var_GeneraInt,  Var_TipoInteres,  Var_EsServicio, Var_EsBancaria,
			Var_MinimoApert,  Var_ComApertura,  Var_ComManeCta, Var_ComAnivers, Var_CobraBanEle,
			Var_CobraSpei,  Var_ComFalsoCo, Var_ExPrDiaSeg, Var_ComDispSeg, Var_SalMinReq
		  FROM TIPOSCUENTAS
			WHERE TipoCuentaID = Var_TipoCuenta;


			SELECT  Var_Descripcion,  Var_GeneraInt,    Var_TipoInteres,  Var_EsServicio,   Var_EsBancaria,
			Var_MinimoApert,  Var_ComApertura,  Var_ComManeCta,   Var_ComAnivers,   Var_CobraBanEle,
			Var_CobraSpei,    Var_ComFalsoCo,   Var_ExPrDiaSeg,   Var_ComDispSeg,   Var_SalMinReq ,
			NomInstit,      NomCortoInst,     DirecInst,      FechEsc,      Var_NomLocRP,
					Var_EscrituraPublic,Var_VolumenEsc,   Var_Notaria,    Var_NomNotario,   Var_TxtEscritura,

					Var_TxtNotaria1,
					ROUND(Var_TasaRend,2) AS Var_TasaRend,
					Var_DomSucursal;

		END IF;
	END IF;
	-- TERMINA SECCION PARA FEMAZA
	-- contrato FinSocial

	IF(Par_NumCon = Con_PortadaFinSoc) THEN

	  SELECT  I.NombreCorto,I.Direccion,TelefonoLocal,NombreRepresentante
		INTO  Var_NombreCortInstFiSoc,Var_DirecionInstFiSoc,Var_TelefonoFiSoc,Var_NomRepreFiSoc
		  FROM PARAMETROSSIS   P,   INSTITUCIONES I
			WHERE   I.InstitucionID=P.InstitucionID;

	   SET Var_NombreCortInstFiSoc:=IFNULL(Var_NombreCortInstFiSoc,Cadena_Vacia);
	   SET Var_DirecionInstFiSoc  :=IFNULL(Var_DirecionInstFiSoc,Cadena_Vacia);
		 SET Var_TelefonoFiSoc    :=IFNULL(Var_TelefonoFiSoc,Cadena_Vacia);
		 SET Var_NomRepreFiSoc    :=IFNULL(Var_NomRepreFiSoc,Cadena_Vacia);



	  SELECT Cah.ClienteID,    Tp.GatInformativo,  Cli.NombreCompleto,  Tp.NumRegistroRECA,  MIN(TaAho.MontoInferior),    TaAho.Tasa
		INTO Var_ClienteIdFiSoc,  Var_GatInforFiSoc,  Var_NomComplCliFiSoc, Var_RECACFinSoc,  Var_MontoMiniFiSoc,    Var_TasInteresFiSoc
		FROM CUENTASAHO Cah, CLIENTES Cli,TIPOSCUENTAS Tp,TASASAHORRO TaAho
		  WHERE Cah.ClienteID=Cli.ClienteID
			AND Tp.TipoCuentaID=Cah.TipoCuentaID
			AND TaAho.TipoCuentaID=Cah.TipoCuentaID
			AND Cli.TipoPersona=TaAho.TipoPersona
			AND Cah.CuentaAhoID=Par_CuentaAhoID;
	   SET Var_RECACFinSoc:=IFNULL(Var_RECACFinSoc,Cadena_Vacia);
	   SET Var_NomComplCliFiSoc:=IFNULL(Var_NomComplCliFiSoc,Cadena_Vacia);
	   SET Var_GatInforFiSoc:=IFNULL(Var_GatInforFiSoc,Entero_Cero);
	   SET Var_TasInteresFiSoc:=IFNULL(Var_TasInteresFiSoc,Entero_Cero);
	   SET Var_MontoMiniFiSoc:=IFNULL(Var_MontoMiniFiSoc,Entero_Cero);
	   SET Var_ClienteIDCFinS:=Var_ClienteIdFiSoc ;

	   WHILE 12>CHAR_LENGTH(Var_ClienteIDCFinS) DO
		SET Var_ClienteIDCFinS:=CONCAT(Entero_Cero,Var_ClienteIDCFinS);
	  END WHILE;

	  SELECT  Var_NombreCortInstFiSoc,  Var_DirecionInstFiSoc, Var_ClienteIDCFinS, Var_NomComplCliFiSoc,  Var_GatInforFiSoc,
		  Var_TasInteresFiSoc,      Var_MontoMiniFiSoc,   Var_RECACFinSoc,   Var_TelefonoFiSoc,   Var_NomRepreFiSoc;

	END IF;

	IF(Par_NumCon = Con_SolicitudFinSoc) THEN

	  SELECT  Cta.ClienteID,    Tp.Descripcion,   Tp.NivelID,         Cta.FechaApertura,
		  S.DirecCompleta
	   INTO   Var_ClienteIdFiSoc, Var_DescCtaFinSoc,  Var_NivelCtaFinSoc,     Var_FecApCtaFinSoc,
		  Var_DirSucurFinSoc
		FROM CUENTASAHO Cta, TIPOSCUENTAS Tp , SUCURSALES S
		  WHERE Cta.TipoCuentaID=Tp.TipoCuentaID
					AND S.SucursalID  = Cta.SucursalID
			AND Cta.CuentaAhoID = Par_CuentaAhoID;
	  SELECT
		CONCAT(Cli.PrimerNombre,(CASE WHEN IFNULL(Cli.SegundoNombre, '')!='' THEN CONCAT(' ',Cli.SegundoNombre) ELSE ' ' END ),
		(CASE WHEN IFNULL(Cli.TercerNombre, '')!='' THEN CONCAT(' ',Cli.TercerNombre) ELSE ' ' END ))AS nombreCLi,
		(CASE WHEN IFNULL(Cli.ApellidoPaterno, '')!='' THEN CONCAT(' ',Cli.ApellidoPaterno) ELSE ' ' END ) AS apelliMat,
		(CASE WHEN IFNULL(Cli.ApellidoMaterno, '')!='' THEN CONCAT(' ',Cli.ApellidoMaterno) ELSE ' ' END )AS apelliPat,
		Cli.CURP,
		Cli.RFC,

		Cli.Nacion,       Cli.EstadoCivil,    Cli.Sexo,       Cli.Correo,     Cli.FechaNacimiento,
		Cli.Telefono,     Cli.TelefonoCelular,  Cli.NombreCompleto,   Cli.LugardeTrabajo, Cli.TipoPersona,
		PM.NombrePromotor,    Cli.PromotorActual

	   INTO   Var_NombresCliFinS,
		  Var_ApellCliPFinS,
		  Var_ApellCliMFinS,
		  Var_CliCURPFinS,
		  Var_CliRFCFinS,

		  Var_CliNacionFinS,    Var_EstadoCivilFinS,  Var_CliGeneroFinS,    Var_CliCorreoFinS,    Var_FechNFinS,
		  Var_CliTelCasaFinS,   Var_CliTelCelFinS,    Var_NomComplCliFiSoc, Var_LugarTrabjFinS,   Var_TipoPersoFiSoc,
		  Var_NomPromoFinSoc,   Var_PromotorFinS
		FROM CLIENTES Cli, PROMOTORES PM
		  WHERE
			 PM.PromotorID=Cli.PromotorActual
			AND Cli.ClienteID=Var_ClienteIdFiSoc;
	  SET Var_CliNacionFinS := CASE WHEN Var_CliNacionFinS =Nac_Mexicano THEN
						  UPPER(NNacional)
											ELSE
						  UPPER(NExtranjero) END ;

	   SET Var_EstadoCivilFinS := CASE  WHEN Var_EstadoCivilFinS =Est_Soltero     THEN Des_Soltero
					  WHEN Var_EstadoCivilFinS =Est_CasBieSep   THEN Des_CasBieSep
					  WHEN Var_EstadoCivilFinS =Est_CasBieMan   THEN Des_CasBieMan
					  WHEN Var_EstadoCivilFinS =Est_CasCapitu   THEN Des_CasCapitu
					  WHEN Var_EstadoCivilFinS =Est_Viudo     	THEN Des_Viudo
					  WHEN Var_EstadoCivilFinS =Est_Divorciad   THEN Des_Divorciad
					  WHEN Var_EstadoCivilFinS =Est_Seperados   THEN Des_Seperados
					  WHEN Var_EstadoCivilFinS =Est_UnionLibre  THEN Des_UnionLibre
					  ELSE
						Cadena_Vacia END ;
	  SELECT CP.NombreCompleto,CP.RFC,CP.Domicilio
		INTO Var_ProprFinS,Var_RFCRFinS,Var_DireccionRFinS
		  FROM CUENTASPERSONA  CP
			WHERE  CP.EsPropReal =Var_SI
			  AND  CuentaAhoID=Par_CuentaAhoID  LIMIT 1;

	  IF    IFNULL(Var_ProprFinS,Cadena_Vacia)=Cadena_Vacia THEN
		SET Var_RecursoPFinSoc := RecursosPropios;
		ELSE
		SET Var_RecursoPFinSoc := RecursosTerceros;
	  END IF;

	  SELECT  Ocu.Descripcion,Ocu.ImplicaTrabajo
		 INTO    Var_OcupacionFinS, Var_EmplFormFinS
		FROM CLIENTES Cli,OCUPACIONES Ocu
		   WHERE  Ocu.OcupacionID=Cli.OcupacionID
		  AND Cli.ClienteID=Var_ClienteIdFiSoc;

	  SELECT   CCTE.PEPs, FP.Descripcion, CCTE.ParentescoPEP
		INTO  Var_PEPsFinS,     Var_DesPuesTPEPFinS,  Var_ParentPEPSFinS
		FROM CLIENTES Cli,CONOCIMIENTOCTE CCTE,FUNCIONESPUB FP
		  WHERE CCTE.FuncionID=FP.FuncionID
			AND CCTE.ClienteID=Cli.ClienteID
			AND Cli.ClienteID=Var_ClienteIdFiSoc;

	  SET Var_CliCorreoFinS   :=IFNULL(Var_CliCorreoFinS,Cadena_Vacia);
	  SET Var_CliRFCFinS      :=IFNULL(Var_CliRFCFinS,Cadena_Vacia);
	  SET Var_OcupacionFinS   :=IFNULL(Var_OcupacionFinS,Cadena_Vacia);
	  SET Var_FechNFinS       :=IFNULL(Var_FechNFinS,Fecha_Vacia);
	  SET Var_EmplFormFinS    :=IFNULL(Var_EmplFormFinS,Cadena_Vacia);
	  SET Var_CliTelCasaFinS  :=IFNULL(Var_CliTelCasaFinS,Cadena_Vacia);
	  SET Var_CliTelCelFinS   :=IFNULL(Var_CliTelCelFinS,Cadena_Vacia);
	  SET Var_NomComplCliFiSoc:=IFNULL(Var_NomComplCliFiSoc,Cadena_Vacia);
	  SET Var_PEPsFinS    	  :=IFNULL(Var_PEPsFinS,Cadena_Vacia);
	  SET Var_DesPuesTPEPFinS :=IFNULL(Var_DesPuesTPEPFinS,Cadena_Vacia);
	  SET Var_ParentPEPSFinS  :=IFNULL(Var_ParentPEPSFinS,Cadena_Vacia);
	  SET Var_LugarTrabjFinS  :=IFNULL(Var_LugarTrabjFinS,Cadena_Vacia);
	  SET Var_TipoPersoFiSoc  :=IFNULL(Var_TipoPersoFiSoc,Cadena_Vacia);
	  SET Var_NomPromoFinSoc  :=IFNULL(Var_NomPromoFinSoc,Cadena_Vacia);

	  SELECT
		DC.Calle,     DC.NumeroCasa,    DC.Colonia,     MR.Nombre,      ER.Nombre,
		DC.CP,        DC.NumInterior,   NombreLocalidad
	   INTO
		Var_CliCalleFinS, Var_CliNumCasaFinS, Var_CliColoniFinS,  Var_CliColMunFinS,  Var_CliEstadoFinS,
		Var_CliCPFinS,    Var_CliNumIntFinS,  Var_CliCiudadFinS
		FROM DIRECCLIENTE   DC
		   LEFT OUTER JOIN ESTADOSREPUB ER  ON  ER.EstadoID = DC.EstadoID
		   LEFT OUTER JOIN MUNICIPIOSREPUB MR   ON  MR.MunicipioID  = DC.MunicipioID AND MR.EstadoID  = DC.EstadoID
		   LEFT OUTER JOIN LOCALIDADREPUB LB  ON  LB.LocalidadID  = DC.LocalidadID AND LB.EstadoID  = DC.EstadoID AND LB.EstadoID = DC.EstadoID
		  WHERE ClienteID = Var_ClienteIdFiSoc
			AND TipoDireccionID = 1
			AND Oficial = Var_SI LIMIT 1;

		SET Var_CliCalleFinS  :=IFNULL(Var_CliCalleFinS,Cadena_Vacia);
	  SET Var_CliNumCasaFinS  :=IFNULL(Var_CliNumCasaFinS,Cadena_Vacia);
		SET Var_CliColoniFinS :=IFNULL(Var_CliColoniFinS,Cadena_Vacia);
		SET Var_CliColMunFinS :=IFNULL(Var_CliColMunFinS,Cadena_Vacia);
	  SET Var_CliEstadoFinS :=IFNULL(Var_CliEstadoFinS,Cadena_Vacia);
	  SET Var_CliCPFinS   :=IFNULL(Var_CliCPFinS,Cadena_Vacia);
		SET Var_CliNumIntFinS :=IFNULL(Var_CliNumIntFinS,Cadena_Vacia);
	  SET Var_CliCiudadFinS :=IFNULL(Var_CliCiudadFinS,Cadena_Vacia);

	  SELECT DATE(FechaConsulta),  MAX(FolioConsulta),    MAX(FolioConsultaC)
		INTO Var_FecConBuFinSoc,    Var_FolConBuFinSoc, Var_FolCoBuCFinSoc
		FROM SOLBUROCREDITO
		  WHERE  RFC=Var_CliRFCFinS GROUP BY FechaConsulta ORDER BY FechaConsulta  DESC LIMIT 1 ;

	  SELECT TipoViviendaID,TiempoHabitarDom
		INTO  Var_TipoVivIIDFinS,Var_TiemHabiDomFinS
		  FROM SOCIODEMOVIVIEN  WHERE ClienteID = Var_ClienteIdFiSoc;

	  SELECT UsuarioID
		INTO Var_IDConsulFinSoc
		  FROM  BUCREPARAMETROS LIMIT 1;

		SET Var_ConseFirmaCFinS := (SELECT MAX(Consecutivo) FROM FIRMAREPLEGAL F
	   INNER  JOIN PARAMETROSSIS P
	   ON F.RepresentLegal =
	   P.NombreRepresentante);

	  SELECT  FRL.Recurso INTO Var_RecurFirmCFinS
		FROM PARAMETROSSIS PS
		  INNER  JOIN FIRMAREPLEGAL FRL
			ON PS.NombreRepresentante = FRL.RepresentLegal
		  AND FRL.Consecutivo       = Var_ConseFirmaCFinS;

	  SELECT Id.NumIdentific,Nombre
		INTO Var_NumIdenFinS, Var_TipoIdenFinS
		  FROM IDENTIFICLIENTE Id,TIPOSIDENTI TId
			WHERE   Id.TipoIdentiID=TId.TipoIdentiID
			  AND ClienteID= Var_ClienteIdFiSoc LIMIT 1;

	  SELECT  CONCAT(DAY(Var_FecApCtaFinSoc),' de ',CASE  MONTH(Var_FecApCtaFinSoc)
				  WHEN  mes1  THEN  UPPER(TxtEnero)
				  WHEN  mes2  THEN  UPPER(TxtFebrero)
				  WHEN  mes3  THEN  UPPER(TxtMarzo)
				  WHEN  mes4  THEN  UPPER(TxtAbril)
				  WHEN  mes5  THEN  UPPER(TxtMayo)
				  WHEN  mes6  THEN  UPPER(TxtJunio)
				  WHEN  mes7  THEN  UPPER(TxtJulio)
				  WHEN  mes8  THEN  UPPER(TxtAgosto)
				  WHEN  mes9  THEN  UPPER(TxtSeptiembre)
				  WHEN  mes10 THEN  UPPER(TxtOctubre)
				  WHEN  mes11 THEN  UPPER(TxtNoviembre)
				  WHEN  mes12 THEN  UPPER(TxtDiciembre)
				END,' del  ',YEAR(Var_FecApCtaFinSoc)) INTO Var_FechaCtaLetFinS;

		SET Var_AniosFinS:=IFNULL(Var_AniosFinS,Entero_Cero);
	  SET Var_MesesFinS:=IFNULL(Var_MesesFinS,Entero_Cero);
	  SET Var_AniosFinS :=  Var_TiemHabiDomFinS DIV 12;
		IF Var_AniosFinS >0 THEN
		SET Var_MesesFinS :=  (Var_MesesFinS)-(Var_AniosFinS*12);
		END IF;
		IF Var_MesesFinS <0 THEN
		SET Var_MesesFinS :=  Entero_Cero;
		END IF;
		SET Var_FolConBuFinSoc  :=IFNULL(Var_FolConBuFinSoc,Cadena_Vacia);
		SET Var_FolCoBuCFinSoc  :=IFNULL(Var_FolCoBuCFinSoc,Cadena_Vacia);
		SET Var_ClienteIDCFinS:= Var_ClienteIdFiSoc;
		SET Var_CuentaCFinS   := Par_CuentaAhoID;
		SET Var_RecursoPFinSoc:=IFNULL(Var_RecursoPFinSoc,Var_NO);
	  WHILE 12>CHAR_LENGTH(Var_ClienteIDCFinS) DO
		SET Var_ClienteIDCFinS:=CONCAT(Entero_Cero,Var_ClienteIDCFinS);
		END WHILE;
	  WHILE 11>CHAR_LENGTH(Var_CuentaCFinS) DO
		SET Var_CuentaCFinS:=CONCAT(Entero_Cero,Var_CuentaCFinS);
		END WHILE;
	  SET Var_NumIdenFinS := IFNULL(Var_NumIdenFinS,Cadena_Vacia);
	  SET Var_TipoIdenFinS:=  IFNULL(Var_TipoIdenFinS,Cadena_Vacia);
	  SELECT  Var_NombresCliFinS,                 Var_ApellCliPFinS,    Var_ApellCliMFinS,  Var_CliCURPFinS,    Var_CliRFCFinS,
		  UPPER(Var_CliNacionFinS)AS Var_CliNacionFinS,   Var_EstadoCivilFinS,  Var_CliGeneroFinS,  Var_CliCorreoFinS,  Var_OcupacionFinS,
		  Var_FechNFinS,                      Var_EmplFormFinS,   Var_CliTelCasaFinS, Var_CliTelCelFinS,    Var_NomComplCliFiSoc,
		  Var_PEPsFinS,                       Var_DesPuesTPEPFinS,  Var_ParentPEPSFinS, Var_LugarTrabjFinS,   Var_ClienteIDCFinS,
		  Var_CliCalleFinS,                   Var_CliNumCasaFinS,   Var_CliColoniFinS,  Var_CliColMunFinS,    Var_CliEstadoFinS,
		  Var_CliCPFinS,                      Var_CliNumIntFinS,    Var_CliCiudadFinS,  Var_TipoVivIIDFinS,   Var_TiemHabiDomFinS,
		  Var_AniosFinS,                      Var_MesesFinS,      Var_DescCtaFinSoc,  Var_NivelCtaFinSoc,   Var_CuentaCFinS,
		  Var_TipoPersoFiSoc,                 Var_RecursoPFinSoc,   Var_FecApCtaFinSoc, Var_DirSucurFinSoc,   Var_NomPromoFinSoc,
		  Var_FecConBuFinSoc,                 Var_FolConBuFinSoc,   Var_FolCoBuCFinSoc, Var_PromotorFinS,   Var_IDConsulFinSoc,
		  Var_RecurFirmCFinS,                 Var_FechaCtaLetFinS,  Var_NumIdenFinS,  Var_TipoIdenFinS,   Var_ProprFinS,
		  Var_RFCRFinS,                   	  Var_DireccionRFinS;
	END IF;

	IF(Par_NumCon = Con_BeneficiCuenta) THEN
	  SELECT CP.NombreCompleto,CP.Porcentaje,Descripcion
		FROM CUENTASPERSONA  CP,TIPORELACIONES TR
		WHERE CP.ParentescoID=TR.TipoRelacionID
		  AND CP.EsBeneficiario =SiBeneficiario
		  AND  CuentaAhoID=Par_CuentaAhoID;
	END IF;

END TerminaStore$$