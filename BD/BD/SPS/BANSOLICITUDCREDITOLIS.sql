DELIMITER ;
DROP PROCEDURE IF EXISTS `BANSOLICITUDCREDITOLIS`;
DELIMITER $$
CREATE PROCEDURE `BANSOLICITUDCREDITOLIS`(
	Par_SolicitudCreditoID			BIGINT(12),				-- Numero de Solicitud de credito
	Par_ClienteID					INT(11),				-- Cliente ID para consultar
	Par_PromotorID					INT(11),				-- Promotor ID para consultar
	Par_NombreCliente				VARCHAR(50),			-- Nombre del cliente
	Par_TamanioLista				INT(11),				-- Parametro tamanio de la lista
	Par_PosicionInicial				INT(11),				-- Parametro posicion inicial de la lista
	Par_Estatus						VARCHAR(20),			-- Cadena con estatus
	Par_SucursalID					INT(11),
	Par_NumLis						TINYINT UNSIGNED,		-- Numero de consulta

	Aud_EmpresaID					INT(11),				-- Parametros de auditoria
	Aud_Usuario						INT(11),				-- Parametros de auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal					INT(11),				-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE Var_LisInfSolicitudCred	TINYINT UNSIGNED;			-- Lista Para consultar la informacion de la solicitud del credito
	DECLARE Lis_FirmaAutSolCred		INT(11); 		--  Numero de listado para consultar las firmas pendientes por autorizar y autorizadas para la solicituf de credito
	DECLARE Lis_DetalleServ			INT(11);

	DECLARE Entero_Cero				INT(1);						-- Entero cero
	DECLARE Cadena_Vacia			CHAR(1);					-- Cadena Vacia
	DECLARE Entero_Uno				INT(11);					-- Entero uno
	DECLARE Entero_Dos				INT(11);					-- Entero dos
	DECLARE Str_SI                  CHAR(1);
	DECLARE Str_NO                  CHAR(1);
	DECLARE Sol_StaInactiva         CHAR(1);
	DECLARE Sol_StaLiberada         CHAR(1);
	DECLARE Sol_StaAutorizada       CHAR(1);
	DECLARE Cre_StaPagado           CHAR(1);
	DECLARE Cre_StaVigente          CHAR(1);
	DECLARE Cre_StaVencido          CHAR(1);
	DECLARE Cre_StaCastigado        CHAR(1);
	DECLARE Sol_StaCancelada		CHAR(1);		-- Estatus cancela de la solicitid

		/* Declaracion de Variables  */
	DECLARE Var_CicloActual         INT(11);
	DECLARE Var_Cliente             INT(11);
	DECLARE Var_MontoSolicitado     DECIMAL(18,2);
	DECLARE Var_MontoMaximo         DECIMAL(18,2);
	DECLARE Var_EsGrupal            CHAR(1);
	DECLARE Var_NumGrupo            INT(11);
	DECLARE Var_CliProEsp			INT;					-- Almacena el Numero de Cliente para Procesos Especificos
	DECLARE Var_Prospecto			INT(11);				-- Almacena el Prospecto
	DECLARE Var_ProductoID			INT(11);				-- Almacena el Producto
	DECLARE Var_Sentencia 			VARCHAR(5000);			-- Consulta dinamica
	DECLARE Var_Where 				VARCHAR(2000);			-- Where dinamico


	-- Asignacion de Constantes
	SET Var_LisInfSolicitudCred			:= 1;						-- Lista Para consultar la informacion de la solicitud del credito
	SET Lis_FirmaAutSolCred				:= 2; 		--  Numero de listado para consultar las firmas pendientes por autorizar y autorizadas para la solicituf de credito
	SET Lis_DetalleServ					:= 3;

	SET Str_SI                  := 'S';
	SET Str_NO                  := 'N';
	SET Sol_StaInactiva         := 'I';     -- Estatus de Solicitud Inactiva
	SET Sol_StaLiberada         := 'L';     -- Estatus de Solicitud Liberada
	SET Sol_StaAutorizada       := 'A';     -- Estatus de Solicitud Autorizada
	SET Cre_StaPagado           := 'P';     -- Estatus de Credito Liquidado
	SET Cre_StaVigente          := 'V';     -- Estatus de Credito Vigente
	SET Cre_StaVencido          := 'B';     -- Estatus de Credito Vencido
	SET Cre_StaCastigado        := 'K';     -- Estatus de Credito Castigado
	SET Sol_StaCancelada		:= 'C';		-- Estatus cancela de la solicitid

	SET Entero_Cero						:= 0;						-- Entero cero
	SET Cadena_Vacia					:= '';						-- Cadena Vacia
	SET Entero_Uno						:= 1;						-- Entero uno
	SET Entero_Dos						:= 2;						-- Entero dos

	SET Par_TamanioLista 		:= IFNULL(Par_TamanioLista, Entero_Cero);
	SET Par_PosicionInicial 	:= IFNULL(Par_PosicionInicial, Entero_Cero);
	SET Par_NombreCliente		:= IFNULL(Par_NombreCliente,Cadena_Vacia);
	SET Par_ClienteID			:= IFNULL(Par_ClienteID, Entero_Cero);
	SET Par_SolicitudCreditoID	:= IFNULL(Par_SolicitudCreditoID, Entero_Cero);
	SET Par_PromotorID			:= IFNULL(Par_PromotorID, Entero_Cero);
	SET Par_Estatus				:= IFNULL(Par_Estatus,Cadena_Vacia);
	SET Par_SucursalID			:= IFNULL(Par_SucursalID,Entero_Cero);
	-- Lista Para consultar la informacion de la solicitud del credito

	IF(LENGTH(Par_Estatus) > 1) THEN
		SET Par_Estatus := REPLACE(Par_Estatus, ',', '\',\'');
	END IF;


	IF Par_NumLis = Var_LisInfSolicitudCred THEN
		SET Var_Sentencia := 'SELECT SOL.SolicitudCreditoID, SOL.FechaAutoriza, SOL.MontoAutorizado, SOL.Estatus, PROM.NombrePromotor, SOL.FechaRegistro, ';
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE SOL.Estatus WHEN "I" THEN "Inactiva"
                                                             WHEN "L" THEN "Liberada"
                                                             WHEN "A" THEN "Autorizada"
                                                             WHEN "C" THEN "Cancelada"
                                                             WHEN "R" THEN "Rechazada"
                                                             WHEN "D" THEN "Desembolsada"
                                                            END AS DescripcionStatus ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'FROM SOLICITUDCREDITO SOL ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'INNER JOIN PROMOTORES PROM ON PROM.PromotorID = SOL.PromotorID ');
		IF(Par_ClienteID > Entero_Cero OR Par_NombreCliente <> Cadena_Vacia) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'INNER JOIN CLIENTES CLI ON CLI.ClienteID = SOL.ClienteID ');
		END IF;
		IF(Par_SucursalID > Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'INNER JOIN SUCURSALES SUC ON SUC.SucursalID = SOL.Sucursal ');
		END IF;

		SET Var_Where := '';
		IF(Par_SolicitudCreditoID > Entero_Cero) THEN
			SET Var_Where := CONCAT('WHERE SOL.SolicitudCreditoID = ', Par_SolicitudCreditoID, ' ');
		END IF;
		IF(Par_ClienteID > Entero_Cero) THEN
			IF(Var_Where = Cadena_Vacia) THEN
				SET Var_Where := CONCAT('WHERE CLI.ClienteID = ', Par_ClienteID, ' ');
			ELSE
				SET Var_Where := CONCAT(Var_Where, 'AND CLI.ClienteID = ', Par_ClienteID, ' ');
			END IF;
		END IF;
		IF(Par_PromotorID > Entero_Cero) THEN
			IF(Var_Where = Cadena_Vacia) THEN
				SET Var_Where := CONCAT('WHERE SOL.PromotorID = ', Par_PromotorID, ' ');
			ELSE
				SET Var_Where := CONCAT(Var_Where, 'AND SOL.PromotorID = ', Par_PromotorID, ' ');
			END IF;
		END IF;
		IF(Par_NombreCliente <> Cadena_Vacia) THEN
			IF(Var_Where = Cadena_Vacia) THEN
				SET Var_Where := CONCAT('WHERE CLI.NombreCompleto LIKE \'%', Par_NombreCliente, '%\' ');
			ELSE
				SET Var_Where := CONCAT(Var_Where, 'AND CLI.NombreCompleto LIKE \'%', Par_NombreCliente, '%\' ');
			END IF;
		END IF;
		IF(Par_Estatus <> Cadena_Vacia) THEN
			IF(Var_Where = Cadena_Vacia) THEN
				SET Var_Where := CONCAT('WHERE SOL.Estatus IN (\'', Par_Estatus, '\') ');
			ELSE
				SET Var_Where := CONCAT(Var_Where, 'AND SOL.Estatus IN (\'', Par_Estatus, '\') ');
			END IF;
		END IF;
		IF(Par_SucursalID > Entero_Cero) THEN
			IF(Var_Where = Cadena_Vacia) THEN
				SET Var_Where := CONCAT('WHERE SOL.SucursalID = ', Par_SucursalID, ' ');
			ELSE
				SET Var_Where := CONCAT(Var_Where, 'AND SOL.SucursalID = ', Par_SucursalID, ' ');
			END IF;
		END IF;
		SET Var_Sentencia := CONCAT(Var_Sentencia, Var_Where);
		SELECT Var_Sentencia;
		SET @ConsultaSolici  = (Var_Sentencia);
		PREPARE SQLDINAMICOSOL FROM @ConsultaSolici;
    	EXECUTE SQLDINAMICOSOL ;
    	DEALLOCATE PREPARE SQLDINAMICOSOL;
	END IF;


	IF(Par_NumLis = Lis_DetalleServ) THEN
		SET Var_Sentencia := 'SELECT SOL.SolicitudCreditoID,SOL.MontoAutorizado, SOL.Estatus, PROM.NombrePromotor, IFNULL(CRE.MontoCredito,0.00) AS MontoCredito, ';
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'PROM.Telefono AS TelefonoPromotor, PROD.Descripcion AS NombreProductoCred, SOL.FechaRegistro, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE SOL.Estatus WHEN "I" THEN "Inactiva"
                                                             WHEN "L" THEN "Liberada"
                                                             WHEN "A" THEN "Autorizada"
                                                             WHEN "C" THEN "Cancelada"
                                                             WHEN "R" THEN "Rechazada"
                                                             WHEN "D" THEN "Desembolsada"
                                                            END AS DescripcionStatus ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'FROM SOLICITUDCREDITO SOL ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'LEFT JOIN CREDITOS CRE ON SOL.CreditoID = CRE.CreditoID  ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'INNER JOIN PRODUCTOSCREDITO PROD ON PROD.ProducCreditoID = SOL.ProductoCreditoID ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'INNER JOIN PROMOTORES PROM ON PROM.PromotorID = SOL.PromotorID ');

		SET Var_Where := '';
		SET Var_Where := '';
		IF(Par_SolicitudCreditoID > Entero_Cero) THEN
			SET Var_Where := CONCAT('WHERE SOL.SolicitudCreditoID = ', Par_SolicitudCreditoID, ' ');
		END IF;
		IF(Par_ClienteID > Entero_Cero) THEN
			IF(Var_Where = Cadena_Vacia) THEN
				SET Var_Where := CONCAT('WHERE SOL.ClienteID = ', Par_ClienteID, ' ');
			ELSE
				SET Var_Where := CONCAT(Var_Where, 'AND SOL.ClienteID = ', Par_ClienteID, ' ');
			END IF;
		END IF;
		IF(Par_Estatus <> Cadena_Vacia) THEN
			IF(Var_Where = Cadena_Vacia) THEN
				SET Var_Where := CONCAT('WHERE SOL.Estatus IN (\'', Par_Estatus, '\') ');
			ELSE
				SET Var_Where := CONCAT(Var_Where, 'AND SOL.Estatus IN (\'', Par_Estatus, '\') ');
			END IF;
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia, Var_Where);

		SET @ConsultaSolici  = (Var_Sentencia);
		PREPARE SQLDINAMICOSOL FROM @ConsultaSolici;
    	EXECUTE SQLDINAMICOSOL ;
    	DEALLOCATE PREPARE SQLDINAMICOSOL;
	END IF;

	-- Numero de listado para consultar las firmas pendientes por autorizar y autorizadas para la solicituf de credito
	IF(Par_NumLis = Lis_FirmaAutSolCred) THEN

		DROP TABLE IF EXISTS TMPAUTFIRMASOLCRED;
		CREATE TEMPORARY TABLE TMPAUTFIRMASOLCRED (
			SolicitudCreditoID			BIGINT(20),
			EsquemaID					INT(11),
			NumFirma					INT(11),
			DescripcionFirma			VARCHAR(100),
			OrganoID					INT(11),
			DescripcionOrgano			VARCHAR(100),
			Autorizada					CHAR(1),

			INDEX (SolicitudCreditoID)
		);

		SELECT Sol.ProductoCreditoID,		Sol.ClienteID,		Sol.MontoSolici,	Sol.ProspectoID, PRO.EsGrupal
			INTO Var_ProductoID,	Var_Cliente,	Var_MontoSolicitado,	Var_Prospecto,	Var_EsGrupal
			FROM SOLICITUDCREDITO Sol
			INNER JOIN PRODUCTOSCREDITO PRO ON PRO.ProducCreditoID = Sol.ProductoCreditoID
			WHERE Sol.SolicitudCreditoID = Par_SolicitudCreditoID;

		-- Si el producto no es grupal el ciclo se determina por el Cliente
		IF IFNULL(Var_EsGrupal, Cadena_Vacia) = Str_NO THEN
			SET Var_MontoMaximo := (SELECT MontoSolici FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicitudCreditoID);

			-- ============== NUEVA SECCION PARA OBTENER EL CICLO ============== --
			IF(Var_Cliente <> Entero_Cero)THEN
				SELECT CicloBase
					INTO Var_CicloActual
					FROM CICLOBASECLIPRO
						WHERE ProductoCreditoID = Var_ProductoID
							AND ClienteID = Var_Cliente
							ORDER BY NumTransaccion DESC
							LIMIT 1;
				ELSE
					SELECT CicloBase
					INTO Var_CicloActual
						FROM CICLOBASECLIPRO
							WHERE ProductoCreditoID=Var_ProductoID
							AND ProspectoID=Var_Prospecto
							ORDER BY NumTransaccion DESC
							LIMIT 1;
			END IF;

			SET	Var_CicloActual	:= IFNULL(Var_CicloActual , Entero_Cero);

			IF(Var_CicloActual = Entero_Cero) THEN
				SET Var_CicloActual := ( SELECT COUNT(CreditoID) FROM CREDITOS 	WHERE ClienteID = Var_Cliente AND Estatus IN (Cre_StaPagado,Cre_StaVigente,Cre_StaVencido) );-- B= VENCIDO, V=VIGENTE, P=PAGADO
				SET	Var_CicloActual	:= IFNULL(Var_CicloActual , Entero_Cero) + 1;
			END IF;

			-- ============== FIN SECCION PARA OBTENER EL CICLO ============== --

		ELSE    --  Si el producto si es grupal el ciclo se determina por el grupo
			SELECT Gru.GrupoID,	Gru.CicloActual
				INTO Var_NumGrupo,	Var_CicloActual
				FROM INTEGRAGRUPOSCRE Inte
				INNER JOIN GRUPOSCREDITO Gru ON Inte.GrupoID = Gru.GrupoID
				WHERE Inte.SolicitudCreditoID = Par_SolicitudCreditoID;

			--  Monto solicitado de todas las solicitudes que integran el grupo
			SET Var_MontoMaximo :=(SELECT SUM(Sol.MontoSolici)
										FROM INTEGRAGRUPOSCRE Inte
										INNER JOIN SOLICITUDCREDITO Sol ON Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
											WHERE Inte.GrupoID = Var_NumGrupo
											AND Sol.Estatus IN (Sol_StaAutorizada, Sol_StaLiberada, Sol_StaCancelada)); -- A=Autorizado, L= LIberada, C= Cancelada

			SET	Var_MontoMaximo	:= IFNULL(Var_MontoMaximo, Entero_Cero);
		END IF;

		SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

		IF Var_MontoSolicitado <= Entero_Cero OR  Var_CicloActual = Entero_Cero THEN
			LEAVE TerminaStore;
		END IF;

		-- Se obtiene el Esquema para solicitudes Nuevas
		INSERT INTO TMPAUTFIRMASOLCRED(SolicitudCreditoID,	EsquemaID,	NumFirma,	OrganoID,	DescripcionOrgano)
			SELECT Par_SolicitudCreditoID,	FIR.EsquemaID,	FIR.NumFirma,	FIR.OrganoID,	ORG.Descripcion
				FROM ESQUEMAAUTORIZA ESQ
				INNER JOIN ORGANOAUTORIZA FIR ON FIR.EsquemaID = ESQ.EsquemaID
				INNER JOIN ORGANODESICION ORG ON ORG.OrganoID = FIR.OrganoID
					WHERE ESQ.ProducCreditoID = Var_ProductoID
						AND Var_CicloActual >= ESQ.CicloInicial
						AND Var_CicloActual <= ESQ.CicloFinal
						AND Var_MontoSolicitado >= ESQ.MontoInicial
						AND Var_MontoSolicitado <= ESQ.MontoFinal
						AND Var_MontoMaximo <= ESQ.MontoMaximo;

		-- Realizamnos el update para identificar si algunos esquemas ya fueron autorizada
		UPDATE TMPAUTFIRMASOLCRED TMP
			SET Autorizada = 'A'
			WHERE NumFirma IN (SELECT NumFirma FROM ESQUEMAAUTFIRMA WHERE SolicitudCreditoID = Par_SolicitudCreditoID);

		-- Realizamnos el update para identificar las esquemas penmdientes por autorizar
		UPDATE TMPAUTFIRMASOLCRED TMP
			SET Autorizada = 'P'
			WHERE NumFirma NOT IN (SELECT NumFirma FROM ESQUEMAAUTFIRMA WHERE SolicitudCreditoID = Par_SolicitudCreditoID);

		-- Actualizamos la descripcion d ela firma
		UPDATE TMPAUTFIRMASOLCRED TMP
			SET TMP.DescripcionFirma = CASE WHEN TMP.NumFirma = 1 THEN 'Firma A'
											WHEN TMP.NumFirma = 2 THEN 'Firma B'
											WHEN TMP.NumFirma = 3 THEN 'Firma C'
											WHEN TMP.NumFirma = 4 THEN 'Firma D'
											WHEN TMP.NumFirma = 5 THEN 'Firma E' END;

		-- Realizamos la consulta final de las firmas de la solicitud de creditos
		SELECT	EsquemaID,		NumFirma,		DescripcionFirma,		OrganoID,		DescripcionOrgano,
				Autorizada
			FROM TMPAUTFIRMASOLCRED
			WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

		DROP TABLE IF EXISTS TMPAUTFIRMASOLCRED;
	END IF;

END TerminaStore$$
