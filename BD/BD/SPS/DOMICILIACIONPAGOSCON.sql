-- SP DOMICILIACIONPAGOSCON

DELIMITER ;

DROP PROCEDURE IF EXISTS DOMICILIACIONPAGOSCON;

DELIMITER $$

CREATE PROCEDURE `DOMICILIACIONPAGOSCON`(
# =======================================================================
# ------------ STORE PARA LA CONSULTA DE DOMICILIACION DE PAGOS ---------
# =======================================================================
	Par_EsNomina			CHAR(1),			-- Indica si la Domiciliacion de Pagos es para Clientes de Nomina o Publico General
	Par_InstitNominaID  	INT(11),			-- ID Institucion de Nomina
    Par_ConvenioNominaID	INT(11),			-- ID Convenio de Nomina
	Par_ClienteID			INT(11),			-- ID del Cliente
	Par_FolioID				BIGINT(20),			-- Numero de Folio

	Par_ConsecutivoID		BIGINT(20),			-- ID Consecutivo
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de Consulta

	Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_ClabeInstitBancaria		VARCHAR(10);			-- Clabe de la Institucion Bancaria
    DECLARE Var_RutaArchivosNomina		VARCHAR(100);			-- Ruta de Archivos de Nomina
    DECLARE Var_FechaArchivo			VARCHAR(50);			-- Fecha en que se genera el Archivo
	DECLARE	Var_FolioID					BIGINT(20);				-- ID Folio

	-- Declaracion de Constantes
	DECLARE Entero_Cero    		INT(11);
	DECLARE Cadena_Vacia   	 	CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
    DECLARE Entero_Diez			INT(11);
    DECLARE Valor_Cobro			CHAR(2);

    DECLARE ConstanteSI			CHAR(1);
    DECLARE ConstanteNO			CHAR(1);
    DECLARE Est_Vigente     	CHAR(1);
    DECLARE Est_Vencido     	CHAR(1);
	DECLARE Est_Afiliada		CHAR(1);

    DECLARE Aplica_Credito		CHAR(1);
    DECLARE Aplica_Ambas		CHAR(1);
    DECLARE TipoCtaSpeiClabe	INT(11);
	DECLARE Est_Activo			CHAR(1);
	DECLARE Est_Incapacidad		CHAR(1);

    DECLARE Est_Permiso			CHAR(1);
    DECLARE Est_Reingreso		CHAR(1);

	DECLARE Con_Clientes		INT(11);
    DECLARE Con_Folio			INT(11);
    DECLARE Con_ParamArchivo	INT(11);
    DECLARE Con_DomiciliaPagos	INT(11);
	DECLARE Con_NumFolio		INT(11);
	DECLARE Con_FolioDomicilia	INT(11);


	-- Asignacion de Constantes
	SET Entero_Cero				:= 0; 				-- Entero Cero
	SET Cadena_Vacia			:= '';   			-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';  	-- Fecha Vacia
    SET Entero_Diez				:= 10;				-- Entero Diez
    SET Valor_Cobro				:= 'CI';			-- Valor Cobro Domiciliacion

	SET ConstanteSI				:= 'S';				-- Constante: SI
    SET ConstanteNO				:= 'N';				-- Constante: NO
    SET Est_Vigente	    		:= 'V'; 			-- Estatus Credito: Vigente
    SET Est_Vencido     		:= 'B'; 			-- Estatus Credito: Vencido
	SET Est_Afiliada			:= 'A';				-- Estatus Domiciliacion: Afiliada

    SET Aplica_Credito			:= 'C';				-- Aplica para: Credito
    SET Aplica_Ambas			:= 'A';				-- Aplica para: Ambas
	SET TipoCtaSpeiClabe		:= 40;				-- Tipo Cuenta Spei: Clabe Interbancaria
	SET Est_Activo				:= 'A';				-- Estatus: Activo
    SET Est_Incapacidad			:= 'I';				-- Estatus: Incapacidad

    SET Est_Permiso				:= 'P';				-- Estatus: Permiso
    SET Est_Reingreso			:= 'E';				-- Estatus: Reingreso

	SET Con_Clientes			:= 1;				-- Consulta de Clientes para Domiciliacion de Pagos
    SET Con_Folio				:= 2;				-- Consulta de Informacion Domiciliacion de Pagos por Folio
    SET Con_ParamArchivo		:= 3;				-- Consulta de Parametros para Generar el Archivo de Domiciliacion de Pagos
    SET Con_DomiciliaPagos		:= 4;				-- Consulta Domiciliacion de Pagos de Convenios de Nomina
    SET Con_NumFolio			:= 5;				-- Consulta Numero de Folios para Generar el Layout de Domiciliacion de Pagos
    SET Con_FolioDomicilia		:= 6;

	-- 1.- Consulta de Clientes para Domiciliacion de Pagos
	IF(Par_NumCon = Con_Clientes)THEN

		IF(Par_EsNomina = ConstanteSI) THEN
			IF(Par_InstitNominaID = Entero_Cero)THEN
				SELECT DISTINCT Cli.ClienteID, Cli.NombreCompleto
                FROM INSTITNOMINA Ins,
					 CONVENIOSNOMINA Con,
					 NOMINAEMPLEADOS Nom,
					 CLIENTES Cli,
					 SOLICITUDCREDITO Sol,
					 CREDITOS Cre,
                     CUENTASTRANSFER Cta
				WHERE Ins.InstitNominaID = Con.InstitNominaID
				  AND Con.ConvenioNominaID = Nom.ConvenioNominaID
				  AND Con.InstitNominaID = Nom.InstitNominaID
				  AND Nom.ClienteID = Cli.ClienteID
				  AND Nom.ClienteID = Sol.ClienteID
                  AND Sol.ClienteID = Cre.ClienteID
				  AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
				  AND Cre.ClienteID = Cta.ClienteID
				  AND Con.Estatus = Est_Activo
				  AND Con.DomiciliacionPagos = ConstanteSI
				  AND Sol.ClabeCtaDomici = Cta.Clabe
                  AND Cre.Estatus IN(Est_Vigente,Est_Vencido)
                  AND Cta.EstatusDomici = Est_Afiliada
				  AND Cta.AplicaPara IN(Aplica_Credito,Aplica_Ambas)
				  AND Cta.TipoCuentaSpei = TipoCtaSpeiClabe
				  AND Sol.InstitucionNominaID != Entero_Cero
                  AND Nom.Estatus IN(Est_Activo,Est_Incapacidad,Est_Permiso,Est_Reingreso)
				  AND Cli.ClienteID = Par_ClienteID;
			END IF;

            IF(Par_InstitNominaID != Entero_Cero)THEN
				SELECT DISTINCT Cli.ClienteID, Cli.NombreCompleto
                FROM INSTITNOMINA Ins,
					 CONVENIOSNOMINA Con,
					 NOMINAEMPLEADOS Nom,
					 CLIENTES Cli,
					 SOLICITUDCREDITO Sol,
					 CREDITOS Cre,
                     CUENTASTRANSFER Cta
				WHERE Ins.InstitNominaID = Con.InstitNominaID
				  AND Con.ConvenioNominaID = Nom.ConvenioNominaID
				  AND Con.InstitNominaID = Nom.InstitNominaID
				  AND Nom.ClienteID = Cli.ClienteID
				  AND Nom.ClienteID = Sol.ClienteID
                  AND Sol.ClienteID = Cre.ClienteID
				  AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
				  AND Cre.ClienteID = Cta.ClienteID
				  AND Con.Estatus = Est_Activo
				  AND Con.DomiciliacionPagos = ConstanteSI
				  AND Sol.ClabeCtaDomici = Cta.Clabe
                  AND Cre.Estatus IN(Est_Vigente,Est_Vencido)
                  AND Cta.EstatusDomici = Est_Afiliada
				  AND Cta.AplicaPara IN(Aplica_Credito,Aplica_Ambas)
				  AND Cta.TipoCuentaSpei = TipoCtaSpeiClabe
                  AND Nom.Estatus IN(Est_Activo,Est_Incapacidad,Est_Permiso,Est_Reingreso)
				  AND Sol.InstitucionNominaID = Par_InstitNominaID
                  AND Con.ConvenioNominaID = Par_ConvenioNominaID
				  AND Cli.ClienteID = Par_ClienteID;
			END IF;
		END IF;

		IF(Par_EsNomina = ConstanteNO)THEN
			SELECT DISTINCT Cli.ClienteID, Cli.NombreCompleto
			FROM CLIENTES Cli,
				 SOLICITUDCREDITO Sol,
				 CREDITOS Cre,
                 CUENTASTRANSFER Cta
			WHERE Cli.ClienteID = Sol.ClienteID
              AND Sol.ClienteID = Cre.ClienteID
			  AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
              AND Cre.ClienteID = Cta.ClienteID
			  AND Sol.ClabeCtaDomici = Cta.Clabe
              AND Cre.Estatus IN(Est_Vigente,Est_Vencido)
              AND Cta.EstatusDomici = Est_Afiliada
              AND Cta.AplicaPara IN(Aplica_Credito,Aplica_Ambas)
              AND Cta.TipoCuentaSpei = TipoCtaSpeiClabe
			  AND (Sol.InstitucionNominaID = Entero_Cero OR Sol.InstitucionNominaID IS NULL)
              AND Cli.ClienteID = Par_ClienteID;
		END IF;

	END IF;

    -- 2.- Consulta de Informacion Domiciliacion de Pagos por Folio
	IF(Par_NumCon = Con_Folio)THEN
        SELECT  FolioID, NumTransaccion
		FROM TMPDETDOMICILIAPAGOS
        WHERE FolioID = Par_FolioID;
	END IF;

    -- 3.- Consulta de Parametros para Generar el Archivo de Domiciliacion de Pagos
    IF(Par_NumCon = Con_ParamArchivo)THEN
		SELECT 	ClabeInstitBancaria
		INTO 	Var_ClabeInstitBancaria
        FROM PARAMETROSSIS;

        SELECT  NombreArchivo, Var_ClabeInstitBancaria, CONCAT(YEAR(FechaRegistro),
			CASE WHEN MONTH(FechaRegistro) < Entero_Diez THEN CONCAT(Entero_Cero,MONTH(FechaRegistro)) ELSE MONTH(FechaRegistro) END,
            CASE WHEN DAY(FechaRegistro) < Entero_Diez THEN CONCAT(Entero_Cero,DAY(FechaRegistro)) ELSE DAY(FechaRegistro)END) AS Var_FechaArchivo,
				CASE WHEN Consecutivo < Entero_Diez THEN CONCAT(Entero_Cero,Consecutivo) ELSE Consecutivo END AS Consecutivo,
				IFNULL(ImporteTotal, Entero_Cero) AS ImporteTotal
        FROM DOMICILIACIONPAGOSENC
        WHERE ConsecutivoID = Par_ConsecutivoID;

    END IF;

    -- 4.- Consulta Domiciliacion de Pagos de Convenios de Nomina
    IF(Par_NumCon = Con_DomiciliaPagos)THEN
		SELECT DomiciliacionPagos
        FROM CONVENIOSNOMINA
        WHERE ConvenioNominaID = Par_ConvenioNominaID
        AND InstitNominaID = Par_InstitNominaID;
	END IF;

    -- 5.- Consulta Numero de Folios para Generar el Layout de Domiciliacion de Pagos
    IF(Par_NumCon = Con_NumFolio)THEN
        -- Se obtiene el Numero de Folio Consecutivo
		CALL FOLIOSAPLICAACT('TMPDETDOMICILIAPAGOS', Var_FolioID);

        SELECT Var_FolioID;
	END IF;


	IF Par_NumCon = Con_FolioDomicilia THEN
		SELECT DISTINCT FolioID FROM DOMICILIACIONPAGOSENC
		WHERE FolioID = Par_FolioID;
	END IF;

END TerminaStore$$