-- SP DOMICILIACIONPAGOSLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS DOMICILIACIONPAGOSLIS;

DELIMITER $$

CREATE PROCEDURE `DOMICILIACIONPAGOSLIS`(
# =======================================================================
# ------------ STORE PARA LA LISTA DE DOMICILIACION DE PAGOS ------------
# =======================================================================
	Par_EsNomina			CHAR(1),			-- Indica si la Domiciliacion de Pagos es para Clientes de Nomina o Publico General
	Par_InstitNominaID  	INT(11),			-- ID Institucion de Nomina
    Par_ConvenioNominaID	INT(11),			-- ID Convenio de Nomina
	Par_ClienteID			INT(11),			-- ID del Cliente
	Par_NombreCliente  		VARCHAR(250),		-- Nombre del Cliente

    Par_Frecuencia			CHAR(2),			-- ID de la Frecuencia
	Par_FolioID				BIGINT(20),			-- Numero de Folio
    Par_Busqueda			VARCHAR(250),		-- Busqueda de Clientes
    Par_NumTransaccion		BIGINT(20),			-- Numero de Transaccion
	Par_Fecha				DATE, 				-- Fecha de alta de archivo de domiciliacion
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista

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
    DECLARE Var_FolioID				BIGINT(20);			-- ID Folio
	DECLARE Var_ConsecutivoID		INT(11);			-- ID Consecutivo
	DECLARE Var_Sentencia 			VARCHAR(10000); 	-- Sentencia

	-- Declaracion de Constantes
	DECLARE Entero_Cero    		INT(11);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Cadena_Vacia   	 	CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE ConstanteSI			CHAR(1);

    DECLARE ConstanteNO			CHAR(1);
    DECLARE Est_Vigente     	CHAR(1);
    DECLARE Est_Vencido     	CHAR(1);
   	DECLARE Est_Afiliada		CHAR(1);
    DECLARE Aplica_Credito		CHAR(1);

    DECLARE Aplica_Ambas		CHAR(1);
    DECLARE TipoCtaSpeiClabe	INT(11);
    DECLARE DescDomiciliacion	VARCHAR(50);
	DECLARE Est_Activo			CHAR(1);
    DECLARE Est_Incapacidad		CHAR(1);

	DECLARE Est_Permiso			CHAR(1);
    DECLARE Est_Reingreso		CHAR(1);

	DECLARE Lis_Clientes	   	INT(11);
    DECLARE Lis_Convenios	   	INT(11);
    DECLARE Lis_DomPagos	   	INT(11);
	DECLARE Lis_DomPagosPag		INT(11);
    DECLARE Lis_Busqueda		INT(11);

    DECLARE Lis_LayoutDomPagos	INT(11);
    DECLARE Lis_FolioDomicilia	INT(11);

	-- Asignacion de Constantes
	SET Entero_Cero				:= 0; 				-- Entero Cero
    SET Decimal_Cero			:= 0.00;			-- Decimal Cero
	SET Cadena_Vacia			:= '';   			-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';  	-- Fecha Vacia
    SET ConstanteSI				:= 'S';				-- Constante: SI

    SET ConstanteNO				:= 'N';				-- Constante: NO
    SET Est_Vigente	    		:= 'V'; 			-- Estatus Credito: Vigente
    SET Est_Vencido     		:= 'B'; 			-- Estatus Credito: Vencido
    SET Est_Afiliada			:= 'A';				-- Estatus Domiciliacion: Afiliada
    SET Aplica_Credito			:= 'C';				-- Aplica para: Credito

    SET Aplica_Ambas			:= 'A';				-- Aplica para: Ambas
	SET TipoCtaSpeiClabe		:= 40;				-- Tipo Cuenta Spei: Clabe Interbancaria
    SET DescDomiciliacion		:= 'PAGO CREDITO BIENESTAR';	-- Descripcion Domiciliacion de Pagos
	SET Est_Activo				:= 'A';				-- Estatus: Activo
    SET Est_Incapacidad			:= 'I';				-- Estatus: Incapacidad

	SET Est_Permiso				:= 'P';				-- Estatus: Permiso
    SET Est_Reingreso			:= 'E';				-- Estatus: Reingreso

	SET Lis_Clientes			:= 1;				-- Lista de Clientes para Domiciliacion de Pagos
    SET Lis_Convenios			:= 2;				-- Lista de Convenios de Empresa de Nomina
    SET Lis_DomPagos			:= 3;				-- Lista de Domiciliacion de Pagos
    SET Lis_DomPagosPag			:= 4;				-- Lista de Domiciliacion de Pagos Paginadas
    SET Lis_Busqueda			:= 5;				-- Lista de Busqueda de Domiciliacion de Pagos

	SET Lis_LayoutDomPagos		:= 6;				-- Lista para generar el Layout de Domiciliacion de Pagos
	SET Lis_FolioDomicilia		:= 7;				-- Lista de folios de domiciliacion de pagos

	-- Asignacion de Variables
	SET Var_FolioID				:= 0;

	-- 1.- Lista de Clientes para Domiciliacion de Pagos
	IF(Par_NumLis = Lis_Clientes)THEN

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
				  AND Cli.NombreCompleto LIKE CONCAT("%", Par_NombreCliente, "%")
                  AND Cre.Estatus IN(Est_Vigente,Est_Vencido)
                  AND Cta.EstatusDomici = Est_Afiliada
				  AND Cta.AplicaPara IN(Aplica_Credito,Aplica_Ambas)
				  AND Cta.TipoCuentaSpei = TipoCtaSpeiClabe
				  AND Sol.InstitucionNominaID != Entero_Cero
                  AND Nom.Estatus IN(Est_Activo,Est_Incapacidad,Est_Permiso,Est_Reingreso)
				  LIMIT 0,15;
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
				  AND Cli.NombreCompleto LIKE CONCAT("%", Par_NombreCliente, "%")
                  AND Cre.Estatus IN(Est_Vigente,Est_Vencido)
                  AND Cta.EstatusDomici = Est_Afiliada
				  AND Cta.AplicaPara IN(Aplica_Credito,Aplica_Ambas)
				  AND Cta.TipoCuentaSpei = TipoCtaSpeiClabe
                  AND Nom.Estatus IN(Est_Activo,Est_Incapacidad,Est_Permiso,Est_Reingreso)
				  AND Sol.InstitucionNominaID = Par_InstitNominaID
                  AND Con.ConvenioNominaID = Par_ConvenioNominaID
				  LIMIT 0,15;
			END IF;
		END IF;

        IF(Par_EsNomina = ConstanteNO) THEN
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
			  AND Cli.NombreCompleto LIKE CONCAT("%", Par_NombreCliente, "%")
              AND Cre.Estatus IN(Est_Vigente,Est_Vencido)
              AND Cta.EstatusDomici = Est_Afiliada
              AND Cta.AplicaPara IN(Aplica_Credito,Aplica_Ambas)
              AND Cta.TipoCuentaSpei = TipoCtaSpeiClabe
			  AND Sol.InstitucionNominaID = Entero_Cero
			LIMIT 0,15;
		END IF;

	END IF;

    -- 2.- Lista de Convenios de Empresa de Nomina
	IF(Par_NumLis = Lis_Convenios)THEN
		SELECT ConvenioNominaID, CONCAT('CONVENIO', ' - ', ConvenioNominaID) AS Descripcion
        FROM CONVENIOSNOMINA
        WHERE InstitNominaID = Par_InstitNominaID;
    END IF;

    -- 3.- Lista de Domiciliacion de Pagos para la pantalla Genera Layout Domiciliacion de Pagos
    IF(Par_NumLis = Lis_DomPagos)THEN

		DELETE FROM TMPDETDOMICILIAPAGOS WHERE Usuario = Aud_Usuario;

		-- Lista de Domiciliacion de Pagos de los Creditos que son de Nomina
        IF(Par_EsNomina = ConstanteSI)THEN
			SET Var_Sentencia := '';
			SET Var_Sentencia := CONCAT(Var_Sentencia,' INSERT INTO TMPDETDOMICILIAPAGOS(
																FolioID,		ClienteID, 		NombreCompleto, 	InstitucionID,		NombreInstitucion,
                                                                CuentaClabe, 	CreditoID,		MontoExigible, 		EmpresaID, 			Usuario,
                                                                FechaActual,	DireccionIP,	ProgramaID,			Sucursal,			NumTransaccion) ');

			SET Var_Sentencia := CONCAT(Var_Sentencia,' SELECT  "',Entero_Cero,'",	Cre.ClienteID, 		Cli.NombreCompleto, Ist.InstitucionID,	UPPER(Ist.NombreCorto) AS NombreInstitucion,
																Sol.ClabeCtaDomici, Cre.CreditoID,	FUNCIONEXIGIBLE(Cre.CreditoID), 	"',Par_EmpresaID,'",
                                                                "',Aud_Usuario,'",	NOW(),				"',Aud_DireccionIP,'",				"',Aud_ProgramaID,'",
                                                                "',Aud_Sucursal,'",	"',Aud_NumTransaccion,'" ' );

            SET Var_Sentencia := CONCAT(Var_Sentencia,'  FROM
															INSTITNOMINA Ins,
															CONVENIOSNOMINA Con,
															NOMINAEMPLEADOS Nom,
															CLIENTES Cli,
															SOLICITUDCREDITO Sol,
															CREDITOS Cre,
															CUENTASTRANSFER Cta,
                                                            INSTITUCIONES Ist ');
			SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE Ins.InstitNominaID = Con.InstitNominaID
														  AND Con.ConvenioNominaID = Nom.ConvenioNominaID
														  AND Con.InstitNominaID = Nom.InstitNominaID
														  AND Nom.ClienteID = Cli.ClienteID
														  AND Nom.ClienteID = Sol.ClienteID
														  AND Sol.ClienteID = Cre.ClienteID
														  AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
														  AND Cre.ClienteID = Cta.ClienteID
														  AND Cta.InstitucionID = Ist.ClaveParticipaSpei
														  AND Sol.ClabeCtaDomici = Cta.Clabe
														  AND Con.Estatus = "',Est_Activo,'"
														  AND Con.DomiciliacionPagos = "',ConstanteSI,'"
														  AND (Cre.Estatus ="',Est_Vigente,'" OR Cre.Estatus ="',Est_Vencido,'")
														  AND Cta.EstatusDomici = "',Est_Afiliada,'"
														  AND (Cta.AplicaPara = "',Aplica_Credito,'" OR Cta.AplicaPara ="',Aplica_Ambas,'")
                                                          AND Cta.TipoCuentaSpei = "',TipoCtaSpeiClabe,'"
                                                          AND (Nom.Estatus = "',Est_Activo,'" OR Nom.Estatus="',Est_Incapacidad,'" OR Nom.Estatus="',Est_Permiso,'" OR Nom.Estatus="',Est_Reingreso,'")
                                                          AND Sol.InstitucionNominaID != "',Entero_Cero,'"
                                                          AND Sol.InstitucionNominaID = Nom.InstitNominaID');

            IF(IFNULL(Par_InstitNominaID,Entero_Cero) != Entero_Cero)THEN
				SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' AND Sol.InstitucionNominaID = ',Par_InstitNominaID);
			END IF;

            IF(IFNULL(Par_ConvenioNominaID,Entero_Cero) != Entero_Cero)THEN
				SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' AND Con.ConvenioNominaID = ',Par_ConvenioNominaID);
			END IF;

            IF(IFNULL(Par_ClienteID,Entero_Cero) != Entero_Cero)THEN
				SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' AND Cli.ClienteID = ',Par_ClienteID);
			END IF;

			IF(IFNULL(Par_Frecuencia,Cadena_Vacia) != Cadena_Vacia)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cre.FrecuenciaCap = "',Par_Frecuencia,'"');
			END IF;

            SET Var_Sentencia 	:=  CONCAT(Var_Sentencia, ' ORDER BY Cre.ClienteID ; ');

			SET @Sentencia		:= (Var_Sentencia);

			PREPARE DOMICILIACIONPAGOS FROM @Sentencia;
			EXECUTE DOMICILIACIONPAGOS;
			DEALLOCATE PREPARE DOMICILIACIONPAGOS;

            -- Se obtiene el total de la cuota de proyeccion (Capital + Interés + IVA Int), de los creditos que aun no tienen el Monto Exigible
			UPDATE TMPDETDOMICILIAPAGOS
            SET MontoExigible = (SELECT FUNCIONCREPROXPAGO(CreditoID,Cadena_Vacia))
            WHERE MontoExigible = Decimal_Cero;

            -- Se obtiene el Numero de Folio Consecutivo
			CALL FOLIOSAPLICAACT('TMPDETDOMICILIAPAGOS', Var_FolioID);

            -- Se actualiza el valor del Folio
			UPDATE TMPDETDOMICILIAPAGOS
			SET FolioID = Var_FolioID
			WHERE NumTransaccion = Aud_NumTransaccion;

            -- Se obtiene el resultado para mostrarlo en el Detalle de la pantalla Genera Laoyout Domiciliacion de Pagos
			SELECT  ConsecutivoID,	ClienteID,	NombreCompleto,	InstitucionID,	NombreInstitucion,
					CuentaClabe,	CreditoID,	MontoExigible,	FolioID,		NumTransaccion
			FROM TMPDETDOMICILIAPAGOS
			WHERE NumTransaccion = Aud_NumTransaccion
			AND MontoExigible > Decimal_Cero
			ORDER BY ClienteID;

        END IF;

        -- Lista de Domiciliacion de Pagos de los Creditos que No son de Nomina
		IF(Par_EsNomina = ConstanteNO)THEN
			SET Var_Sentencia := '';
			SET Var_Sentencia := CONCAT(Var_Sentencia,' INSERT INTO TMPDETDOMICILIAPAGOS(
																FolioID,		ClienteID, 		NombreCompleto, 	InstitucionID,		NombreInstitucion,
                                                                CuentaClabe, 	CreditoID,		MontoExigible, 		EmpresaID, 			Usuario,
                                                                FechaActual,	DireccionIP,	ProgramaID,			Sucursal,			NumTransaccion) ');

			SET Var_Sentencia := CONCAT(Var_Sentencia,' SELECT  "',Entero_Cero,'",	Cre.ClienteID, 		Cli.NombreCompleto, Ins.InstitucionID,	UPPER(Ins.NombreCorto) AS NombreInstitucion,
																Sol.ClabeCtaDomici, Cre.CreditoID,	FUNCIONEXIGIBLE(Cre.CreditoID), 	"',Par_EmpresaID,'",
                                                                "',Aud_Usuario,'",	NOW(),				"',Aud_DireccionIP,'",				"',Aud_ProgramaID,'",
                                                                "',Aud_Sucursal,'",	"',Aud_NumTransaccion,'" ' );
			SET Var_Sentencia := CONCAT(Var_Sentencia,'  FROM
															CLIENTES Cli,
															SOLICITUDCREDITO Sol,
															CREDITOS Cre,
															CUENTASTRANSFER Cta,
															INSTITUCIONES Ins ');
			SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE Cli.ClienteID = Sol.ClienteID
														  AND Sol.ClienteID = Cre.ClienteID
														  AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
														  AND Cre.ClienteID = Cta.ClienteID
														  AND Cta.InstitucionID = Ins.ClaveParticipaSpei
														  AND Sol.ClabeCtaDomici = Cta.Clabe
														  AND (Cre.Estatus ="',Est_Vigente,'" OR Cre.Estatus ="',Est_Vencido,'")
														  AND Cta.EstatusDomici = "',Est_Afiliada,'"
														  AND (Cta.AplicaPara = "',Aplica_Credito,'" OR Cta.AplicaPara ="',Aplica_Ambas,'")
														  AND Cta.TipoCuentaSpei = "',TipoCtaSpeiClabe,'"
														  AND (Sol.InstitucionNominaID = "',Entero_Cero,'" OR Sol.InstitucionNominaID IS NULL ) ');

			IF(IFNULL(Par_ClienteID,Entero_Cero) != Entero_Cero)THEN
				SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' AND Cli.ClienteID = ',Par_ClienteID);
			END IF;

			IF(IFNULL(Par_Frecuencia,Cadena_Vacia) != Cadena_Vacia)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cre.FrecuenciaCap = "',Par_Frecuencia,'"');
			END IF;

            SET Var_Sentencia 	:=  CONCAT(Var_Sentencia, ' ORDER BY Cre.ClienteID ; ');

			SET @Sentencia		:= (Var_Sentencia);

			PREPARE DOMICILIACIONPAGOS FROM @Sentencia;
			EXECUTE DOMICILIACIONPAGOS;
			DEALLOCATE PREPARE DOMICILIACIONPAGOS;

            -- Se obtiene el total de la cuota de proyeccion (Capital + Interés + IVA Int), de los creditos que aun no tienen el Monto Exigible
			UPDATE TMPDETDOMICILIAPAGOS
            SET MontoExigible = (SELECT FNEXIGEDOMICILIACRE(CreditoID))
            WHERE MontoExigible = Decimal_Cero;

            -- Se obtiene el Numero de Folio Consecutivo
			CALL FOLIOSAPLICAACT('TMPDETDOMICILIAPAGOS', Var_FolioID);

            -- Se actualiza el valor del Folio
			UPDATE TMPDETDOMICILIAPAGOS
			SET FolioID = Var_FolioID
			WHERE NumTransaccion = Aud_NumTransaccion;

            -- Se obtiene el resultado para mostrarlo en el Detalle de la pantalla Genera Laoyout Domiciliacion de Pagos
			SELECT  ConsecutivoID,	ClienteID,	NombreCompleto,	InstitucionID,	NombreInstitucion,
					CuentaClabe,	CreditoID,	MontoExigible,	FolioID,		NumTransaccion
			FROM TMPDETDOMICILIAPAGOS
			WHERE NumTransaccion = Aud_NumTransaccion
            AND MontoExigible > Decimal_Cero
			ORDER BY ClienteID;

        END IF;

	END IF;

	-- 4.- Lista de Domiciliacion de Pagos Paginadas
    IF(Par_NumLis = Lis_DomPagosPag)THEN
		SELECT  ConsecutivoID,	ClienteID,	NombreCompleto,	InstitucionID,	NombreInstitucion,
				CuentaClabe,	CreditoID,	MontoExigible,	FolioID,		NumTransaccion
		FROM TMPDETDOMICILIAPAGOS
		WHERE NumTransaccion = Par_NumTransaccion
		AND MontoExigible > Decimal_Cero
		ORDER BY ClienteID;
    END IF;

	-- 5.- Lista de Busqueda de Domiciliacion de Pagos
    IF(Par_NumLis = Lis_Busqueda)THEN
		SELECT  ConsecutivoID,	ClienteID,	NombreCompleto,	InstitucionID,	NombreInstitucion,
				CuentaClabe,	CreditoID,	MontoExigible,	FolioID,		NumTransaccion
		FROM TMPDETDOMICILIAPAGOS
		WHERE NombreCompleto LIKE CONCAT("%", Par_Busqueda, "%")
		AND NumTransaccion = Par_NumTransaccion
		AND MontoExigible > Decimal_Cero
		ORDER BY ClienteID;
    END IF;

    -- 6.- Lista para generar el Layout de Domiciliacion de Pagos
    IF(Par_NumLis = Lis_LayoutDomPagos)THEN
		SELECT  NoEmpleado, Referencia, CuentaClabe, MontoExigible, CreditoID,
				DescDomiciliacion AS Descripcion
		FROM 	DOMICILIACIONPAGOS
        WHERE FolioID = Par_FolioID;
    END IF;


     -- 7.- Lista de ayuda de Domiciliacion de Pagos
    IF(Par_NumLis = Lis_FolioDomicilia)THEN
		SELECT  FechaRegistro, FolioID, NombreArchivo
		FROM 	DOMICILIACIONPAGOSENC
        WHERE NombreArchivo LIKE CONCAT("%", Par_Busqueda, "%")
        AND FechaRegistro = Par_Fecha;

    END IF;

END TerminaStore$$
