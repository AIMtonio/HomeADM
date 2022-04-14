-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSCREDITOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSCREDITOCON`;

DELIMITER $$
CREATE PROCEDURE `GRUPOSCREDITOCON`(
	/*SP PARA CONSULTAR CREDITOS GRUPALES*/
	Par_GrupoID        		 	INT(11),			-- Numero de Grupo
	Par_CicloGrupo      		INT(11),			-- Numero de Ciclo del Grupo
	Par_NumCon          		TINYINT UNSIGNED,	-- Numero de Consulta

	Aud_EmpresaID       		INT(11),			-- Parametro Empresa ID
	Aud_Usuario         		INT(11),			-- Parametro Usuario ID
	Aud_FechaActual     		DATETIME,			-- Parametro Fecha Actual
	Aud_DireccionIP     		VARCHAR(15),		-- Parametro Direccion ID
	Aud_ProgramaID      		VARCHAR(50),		-- Parametro Programa ID
	Aud_Sucursal        		INT(11),			-- Parametro Sucursal ID
	Aud_NumTransaccion  		BIGINT(20)			-- Parametro Numero Transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Mon_TotDeuda    		DECIMAL(14,2);	-- Total de la Deuda
	DECLARE Mon_TotProyecta 		DECIMAL(14,2);	-- Total Proyectado
	DECLARE Var_NombreGrupo 		VARCHAR(200);	-- Nombre del Grupo
	DECLARE Var_Integrantes  		INT(11);		-- Numero de Integrantes
	DECLARE Var_VerificaGpo  		INT(11);		-- Verifica el Grupo
	DECLARE Var_Cliente      		INT(11);		-- Numero de Cliente
	DECLARE Var_PromotorAct  		INT(11);		-- Promotor Actual
	DECLARE Var_NombPromotor 		VARCHAR(250);	-- Nombre del Promotor Actual
	DECLARE Var_TotalInteg      	INT(11);		-- Total de Integrantes
	DECLARE Var_TotaHomb      		INT(11);		-- Total de hombres
	DECLARE Var_TotaMujer       	INT(11);		-- Total de Mujeres
	DECLARE Var_TotaMujerS     		INT(11);		-- Total de Mujeres
	DECLARE Var_CicloActual 		INT(11);		-- Ciclo Actual
	DECLARE Var_TotalIntegCte 		INT(11);		-- Total de Integrantes Clientes
	DECLARE Var_TotalIntegPros		INT(11);		-- Total de Integrantes Prospectos
	DECLARE Var_TotaMujerCte		INT(11);		-- Total de Mujeres Clientes
	DECLARE Var_TotaMujerPros		INT(11);		-- Total de Mujeres Prospectos
	DECLARE Var_TotaHombCte			INT(11);		-- Total de Hombre Cliente
	DECLARE Var_TotaHombPros		INT(11);		-- Total de Hombre Prospectos
	DECLARE Var_TotaMujerCtes		INT(11);		-- Total de Mujeres Clientes
	DECLARE Var_TotaMujerProsp		INT(11);		-- Total de Mujeres Prospectos
	DECLARE Var_AtiendeSucursales   CHAR(1);		-- Atiende Sucursales
	DECLARE Var_SucursalUsuario     INT(11);		-- Usuario de Sucursal
	DECLARE Var_GrupoID				INT(11);		-- Grupo ID
    DECLARE Var_FechaSistema		DATE;			-- Fecha de Sistema
	DECLARE Var_Ciclo				INT(11);
	DECLARE Var_CreditoID			BIGINT(12);		-- Variable para almacenar el credito del tesorero

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    		CHAR(1);
	DECLARE Fecha_Vacia     		DATE;
	DECLARE Entero_Cero     		INT(11);
	DECLARE Con_Principal   		INT(11);
	DECLARE Con_TotExigible 		INT(11);
	DECLARE Con_TotDeuda    		INT(11);
	DECLARE Con_CreIntegra  		INT(11);
	DECLARE Con_ValidaInt   		INT(11);
	DECLARE Con_CicloGpo	  		INT(11);
	DECLARE Con_PerfilGpo   		INT(11);
	DECLARE Con_IntGpo      		INT(11);
	DECLARE Con_Condonacion      	INT(11);
	DECLARE Con_Finiquito   		INT(11);
	DECLARE Con_RompGrupo   		INT(11);
	DECLARE Con_SolLiberada   		INT(11);
    DECLARE Con_Agropecuario		INT(11);
	DECLARE Esta_Activo     		CHAR(1);
	DECLARE Esta_Vencido    		CHAR(1);
	DECLARE Esta_Vigente    		CHAR(1);
	DECLARE Con_PagareGrupo         INT(11);
	DECLARE Con_ExisteGrupo			INT(11);

	DECLARE Esta_Pagado    		 	CHAR(1);
	DECLARE Si_Prorratea    		CHAR(1);
	DECLARE CargoPresidente 		INT(11);
	DECLARE Si_DirEsOficial 		CHAR(1);
	DECLARE Integ_Activo   		 	CHAR(1);
	DECLARE Est_Act         		CHAR;
	DECLARE Sex_F          		 	CHAR(1);
	DECLARE Sex_M           		CHAR(1);
	DECLARE EdoSoltero      		CHAR(2);
	DECLARE EstatLiberada      		CHAR(1);
	DECLARE EstatAbierto      		CHAR(1);
    DECLARE Es_Agropecuario			CHAR(1);
    DECLARE No_Es_Agropecuario		CHAR(1);
    DECLARE Con_DesembolsosGrup		INT(11);
	DECLARE Con_GrupoInactiva		INT(11);
	DECLARE Est_Inactivo			CHAR(1);
	DECLARE RefPayCash				VARCHAR(20);
	DECLARE CanalCredito			INT(11);
	DECLARE PayCash					INT(11);

	-- Asignacion de Constantes
	SET Cadena_Vacia    		:= '';                  -- Cadena Vacia
	SET Fecha_Vacia     		:= '1900-01-01';        -- Fecha Vacia
	SET Entero_Cero     		:= 0;                   -- Entero En Cero
	SET Esta_Activo     		:= 'A';                 -- Integrante Activo
	SET Esta_Vencido    		:= 'B';                 -- Estatus del Credito Vencido
	SET Esta_Vigente    		:= 'V';                 -- Estatus del Credito Vigente
	SET Esta_Pagado     		:= 'P';                 -- Estatus del Credito Pagado
	SET Si_Prorratea    		:= 'S';                 -- Si Prorratea el Pago en el Grupo
	SET CargoPresidente 		:= 1;                   -- Cargo del Integrante: Presidente
	SET Si_DirEsOficial 		:= 'S';                 -- Tipo de Direccion: Oficial
	SET Con_Principal   		:= 1;                   -- Tipo de Consulta: Principal
	SET Con_TotExigible 		:= 2;                   -- Tipo de Consulta: Total Exigible del Grupo
	SET Con_TotDeuda   			:= 3;                   -- Tipo de Consulta: Total de la Deuda del Grupo
	SET Con_CreIntegra  		:= 4;                   -- Tipo de Consulta: Integrantes Para Comprobante de Pago Ventanilla
	SET Con_ValidaInt   		:= 5;                   -- Tipo de Consulta: Numero de Integrantes del Grupo
	SET Con_CicloGpo    		:= 6;                   -- Tipo de Consulta: Ciclo Actual del Grupo
	SET Con_PerfilGpo   		:= 7;                   -- Tipo de Consulta: Perfil del Grupo
	SET Con_IntGpo      		:= 8;                   -- Tipo de Consulta: Totales de Integrantes del Grupo
	SET Con_Condonacion 		:= 9;                   -- Tipo de Consulta: Exigible para Condonacion
	SET Con_Finiquito   		:= 10;                  -- Tipo de Consulta: Finiquito
	SET Con_RompGrupo           := 11;                  -- Tipo de Consulta: Rompimiento Grupo
	SET Con_SolLiberada         := 12;                  -- Tipo de Consulta: Grupos con Solicitud Liberada
	SET Con_PagareGrupo         := 13;					-- Tipo de consulta: Para Pagare
	SET Con_ExisteGrupo			:= 14;					-- Tipo de consulta: Existencia del Grupo
    SET Con_Agropecuario		:= 15;					-- tipo de consulta
	SET Con_DesembolsosGrup		:= 16;					-- Tipo de consulta: Grupos con creditos desembolsados durante el dia
	SET Con_GrupoInactiva		:= 17;					-- Tipo de Consulta: Solicitudes de creditos con estatus inactivo
	SET Est_Act         		:= 'A';                 -- Estatus de Activo
	SET Integ_Activo    		:= 'A';                 -- Integrantes Activo
	SET Sex_F           		:= 'F';                 -- Genero: Femenino
	SET Sex_M          			:= 'M';                 -- Genero: Masculino
	SET EdoSoltero      		:= 'S';                 -- Estado Civil: Soltero
	SET EstatLiberada           := 'L';  				-- Estatus de Solicitud Liberada
	SET EstatAbierto            := 'A';                 -- Estatus del Ciclo del Grupo: Abierto
	SET Es_Agropecuario			:= 'S';					-- indica que el grupo  es agropecuario
    SET No_Es_Agropecuario		:= 'N';					-- indica que el grupo no es agropecuario
	SET Est_Inactivo			:= 'I';					-- Constante: Estatus inactivo
	SET CanalCredito			:= 1;
	SET PayCash					:= 61;

    SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_CreditoID			:= Entero_Cero;

	IF(Par_NumCon = Con_Principal) THEN
		IF(EXISTS (SELECT GrupoID FROM INTEGRAGRUPOSCRE WHERE GrupoID=Par_GrupoID))THEN

			-- Obtenemos el credito del tesorero
			SELECT 	C.CreditoID
			INTO	Var_CreditoID
			FROM CREDITOS C
				INNER JOIN PRODUCTOSCREDITO P ON C.ProductoCreditoID=P.ProducCreditoID
				INNER JOIN INTEGRAGRUPOSCRE G ON C.SolicitudCreditoID = G.SolicitudCreditoID
				INNER JOIN CLIENTES CTE ON G.ClienteID = CTE.ClienteID
			WHERE G.GrupoID = Par_GrupoID
				AND G.Estatus = Est_Act
				AND G.Cargo = 2;

			-- Obtenemos la referencia
			SELECT 	Referencia
			INTO	RefPayCash
		  	FROM REFPAGOSXINST
			WHERE TipoCanalID = CanalCredito
				AND InstitucionID = PayCash
				AND InstrumentoID = Var_CreditoID;

			SET RefPayCash	:= Var_CreditoID;
			SET RefPayCash	:= IFNULL(RefPayCash, Cadena_Vacia);

				SELECT DISTINCT Gpo.GrupoID,	Gpo.NombreGrupo,		DATE(Gpo.FechaRegistro) AS FechaRegistro,		Gpo.SucursalID,					Gpo.CicloActual,
						Gpo.EstatusCiclo,		Gpo.FechaUltCiclo, 		Pro.ProducCreditoID,							IFNULL(Suc.NombreSucurs, ""),	InG.ProrrateaPago,
						RefPayCash
				FROM 	GRUPOSCREDITO Gpo
					INNER JOIN INTEGRAGRUPOSCRE InG ON Gpo.GrupoID= InG.GrupoID
					INNER JOIN SOLICITUDCREDITO Sol ON InG.SolicitudCreditoID= Sol.SolicitudCreditoID
					INNER JOIN PRODUCTOSCREDITO Pro ON Sol.ProductoCreditoID= Pro.ProducCreditoID
					INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Gpo.SucursalID
						WHERE  	Gpo.GrupoID = Par_GrupoID
								AND Gpo.EsAgropecuario = No_Es_Agropecuario;

		ELSE
				SELECT MAX(Ciclo)  INTO Var_Ciclo
					FROM `HIS-INTEGRAGRUPOSCRE`
					WHERE GrupoID =Par_GrupoID;

				-- Obtenemos el credito del tesorero
				SELECT 	C.CreditoID
				INTO	Var_CreditoID
				FROM CREDITOS C
					INNER JOIN PRODUCTOSCREDITO P ON C.ProductoCreditoID=P.ProducCreditoID
					INNER JOIN `HIS-INTEGRAGRUPOSCRE` G ON C.SolicitudCreditoID = G.SolicitudCreditoID
					INNER JOIN CLIENTES CTE ON G.ClienteID = CTE.ClienteID
				WHERE G.GrupoID = Par_GrupoID
					AND G.Estatus = Est_Act
					AND G.Cargo = 2
				ORDER BY G.SolicitudCreditoID DESC LIMIT 1;

				-- Obtenemos la referencia
				SELECT 	Referencia
				INTO	RefPayCash
				FROM REFPAGOSXINST
				WHERE TipoCanalID = CanalCredito
					AND InstitucionID = PayCash
					AND InstrumentoID = Var_CreditoID;

				SET RefPayCash		:= Var_CreditoID;
				SET RefPayCash		:= IFNULL(RefPayCash, Cadena_Vacia);

                SET Var_Ciclo		:= IFNULL(Var_Ciclo, Entero_Cero);
				SET Var_CreditoID	:= IFNULL(Var_CreditoID, Entero_Cero);

                IF (Var_Ciclo <> Entero_Cero) THEN
					SELECT	Gpo.GrupoID,			Gpo.NombreGrupo,		Gpo.FechaRegistro,		Gpo.SucursalID,					Gpo.CicloActual,
							Gpo.EstatusCiclo,		Gpo.FechaUltCiclo, 		NULL, 					IFNULL(Suc.NombreSucurs, ""),	HIS.ProrrateaPago AS ProrrateaPago, HIS.SolicitudCreditoID,
							RefPayCash
						FROM 	GRUPOSCREDITO Gpo
						INNER JOIN 	SUCURSALES Suc ON Suc.SucursalID = Gpo.SucursalID
						INNER JOIN `HIS-INTEGRAGRUPOSCRE` HIS ON Gpo.GrupoID = HIS.GrupoID
						WHERE  	Gpo.GrupoID =Par_GrupoID
						AND Gpo.EsAgropecuario = No_Es_Agropecuario
						AND HIS.Ciclo=Var_Ciclo
						LIMIT 1;
                ELSE
                	SELECT	Gpo.GrupoID,			Gpo.NombreGrupo,		Gpo.FechaRegistro,		Gpo.SucursalID,					Gpo.CicloActual,
						Gpo.EstatusCiclo,		Gpo.FechaUltCiclo, 		NULL, 					IFNULL(Suc.NombreSucurs, ""),	Cadena_Vacia AS ProrrateaPago,
						Cadena_Vacia AS RefPayCash
					FROM 	GRUPOSCREDITO Gpo,
							SUCURSALES Suc
						WHERE  	Gpo.GrupoID =Par_GrupoID
							AND Suc.SucursalID = Gpo.SucursalID
							 	AND Gpo.EsAgropecuario = No_Es_Agropecuario;
				END IF;
		END IF;
	END IF;

	-- Tipo de Consulta: Total de la Deuda del Grupo, sin Comision por Prepago
	-- Utilizado en: * Pago de Credito (Prepago no Finiquito)
	-- No.Consulta: 3
	IF(Par_NumCon = Con_TotDeuda) THEN

		SELECT NombreGrupo, CicloActual INTO Var_NombreGrupo, Var_CicloActual
			FROM 	GRUPOSCREDITO
			WHERE  	GrupoID = Par_GrupoID;

		SET Var_NombreGrupo := IFNULL(Var_NombreGrupo, Cadena_Vacia);
		SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

		-- Verificamos el Ciclo del Grupo, Si es el Ciclo Actual o si es un Ciclo Anterior
		-- Entonces Buscamos los Integrantes en el Historico
		IF(Par_CicloGrupo = Var_CicloActual) THEN
			SELECT  SUM(FUNCIONTOTDEUDACRE(Cre.CreditoID)) INTO Mon_TotDeuda
				FROM INTEGRAGRUPOSCRE Ing,
					 SOLICITUDCREDITO Sol,
					 CREDITOS Cre
				WHERE Ing.GrupoID               = Par_GrupoID
				  AND Ing.Estatus               = Esta_Activo
				  AND Ing.ProrrateaPago         = Si_Prorratea
				  AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
				  AND Sol.CreditoID             = Cre.CreditoID
				  AND	(   Cre.Estatus		= Esta_Vigente
					   OR  Cre.Estatus		= Esta_Vencido	);
		ELSE
			SELECT  SUM(FUNCIONTOTDEUDACRE(Cre.CreditoID)) INTO Mon_TotDeuda
				FROM `HIS-INTEGRAGRUPOSCRE` Ing,
					 SOLICITUDCREDITO Sol,
					 CREDITOS Cre
				WHERE Ing.GrupoID               = Par_GrupoID
				  AND Ing.Estatus               = Esta_Activo
				  AND Ing.ProrrateaPago         = Si_Prorratea
				  AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
				  AND Ing.Ciclo                 = Par_CicloGrupo
				  AND Sol.CreditoID             = Cre.CreditoID
				  AND	(   Cre.Estatus		= Esta_Vigente
					   OR  Cre.Estatus		= Esta_Vencido	);

		END IF;

		SET Mon_TotDeuda    := IFNULL(Mon_TotDeuda, Entero_Cero);
		SELECT  format(Mon_TotDeuda,2), Var_NombreGrupo;

	END IF;

	-- Tipo de Consulta: Total de la Deuda del Grupo, sin Comision por Prepago
	-- Utilizado en: * Pago de Credito, Exigible
	-- No.Consulta: 2
	IF(Par_NumCon = Con_TotExigible) THEN

		SELECT CicloActual INTO Var_CicloActual
			FROM 	GRUPOSCREDITO
			WHERE  	GrupoID = Par_GrupoID;

		SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

		-- Verificamos el Ciclo del Grupo, Si es el Ciclo Actual o si es un Ciclo Anterior
		-- Entonces Buscamos los Integrantes en el Historico
		IF(Par_CicloGrupo = Var_CicloActual) THEN
			SELECT  SUM(FUNCIONCONPAGOANTCRE(Cre.CreditoID)),
					SUM(FUNCIONPROYECINTECRE(Cre.CreditoID))
					INTO Mon_TotDeuda, Mon_TotProyecta
				FROM INTEGRAGRUPOSCRE Ing,
					 SOLICITUDCREDITO Sol,
					 CREDITOS Cre
				WHERE Ing.GrupoID               = Par_GrupoID
				  AND Ing.Estatus               = Esta_Activo
				  AND Ing.ProrrateaPago         = Si_Prorratea
				  AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
				  AND Sol.CreditoID             = Cre.CreditoID
				  AND	(   Cre.Estatus		= Esta_Vigente
					   OR  Cre.Estatus		= Esta_Vencido	);
		ELSE
			SELECT  SUM(FUNCIONCONPAGOANTCRE(Cre.CreditoID)),
					SUM(FUNCIONPROYECINTECRE(Cre.CreditoID))
					INTO Mon_TotDeuda, Mon_TotProyecta
				FROM `HIS-INTEGRAGRUPOSCRE` Ing,
					 SOLICITUDCREDITO Sol,
					 CREDITOS Cre
				WHERE Ing.GrupoID               = Par_GrupoID
				  AND Ing.Estatus               = Esta_Activo
				  AND Ing.ProrrateaPago         = Si_Prorratea
				  AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
				  AND Ing.Ciclo                 = Par_CicloGrupo
				  AND Sol.CreditoID             = Cre.CreditoID
				  AND	(   Cre.Estatus		= Esta_Vigente
					   OR  Cre.Estatus		= Esta_Vencido	);
		END IF;

		SET Mon_TotDeuda        := IFNULL(Mon_TotDeuda, Entero_Cero);
		SET Mon_TotProyecta     := IFNULL(Mon_TotProyecta, Entero_Cero);

		SELECT Mon_TotDeuda, Mon_TotProyecta;

	END IF;

	-- Tipo de Consulta: Total del Exigible del Grupo sin Proyeccion de interes
	-- Utilizado en: * Pantalla de Condonacion
	-- No.Consulta: 9
	IF(Par_NumCon = Con_Condonacion) THEN

		SELECT CicloActual INTO Var_CicloActual
			FROM 	GRUPOSCREDITO
			WHERE  	GrupoID = Par_GrupoID;

		SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

		-- Verificamos el Ciclo del Grupo, Si es el Ciclo Actual o si es un Ciclo Anterior
		-- Entonces Buscamos los Integrantes en el Historico
		IF(Par_CicloGrupo = Var_CicloActual) THEN
			SELECT  SUM(FUNCIONEXIGIBLE(Cre.CreditoID)) INTO Mon_TotDeuda
				FROM INTEGRAGRUPOSCRE Ing,
					 SOLICITUDCREDITO Sol,
					 CREDITOS Cre
				WHERE Ing.GrupoID               = Par_GrupoID
				  AND Ing.Estatus               = Esta_Activo
				  AND Ing.ProrrateaPago         = Si_Prorratea
				  AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
				  AND Sol.CreditoID             = Cre.CreditoID
				  AND	(   Cre.Estatus		= Esta_Vigente
					   OR  Cre.Estatus		= Esta_Vencido	);
		ELSE
			SELECT  SUM(FUNCIONEXIGIBLE(Cre.CreditoID)) INTO Mon_TotDeuda
				FROM `HIS-INTEGRAGRUPOSCRE` Ing,
					 SOLICITUDCREDITO Sol,
					 CREDITOS Cre
				WHERE Ing.GrupoID               = Par_GrupoID
				  AND Ing.Estatus               = Esta_Activo
				  AND Ing.ProrrateaPago         = Si_Prorratea
				  AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
				  AND Ing.Ciclo                 = Par_CicloGrupo
				  AND Sol.CreditoID             = Cre.CreditoID
				  AND	(   Cre.Estatus		= Esta_Vigente
					   OR  Cre.Estatus		= Esta_Vencido	);
		END IF;

		SET Mon_TotDeuda    := IFNULL(Mon_TotDeuda, Entero_Cero);

		SELECT  Mon_TotDeuda;

	END IF;

	-- Tipo de Consulta: Total del Adeudo incluyendo Comision por Prepago
	-- Utilizado en: * Pantalla de Pago de Credito: Finiquito
	-- No.Consulta: 10
	IF(Par_NumCon = Con_Finiquito) THEN

		SELECT CicloActual INTO Var_CicloActual
			FROM 	GRUPOSCREDITO
			WHERE  	GrupoID = Par_GrupoID;

		SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

		-- Verificamos el Ciclo del Grupo, Si es el Ciclo Actual o si es un Ciclo Anterior
		-- Entonces Buscamos los Integrantes en el Historico
		IF(Par_CicloGrupo = Var_CicloActual) THEN
			SELECT  SUM(FUNCIONCONFINIQCRE(Cre.CreditoID)) INTO Mon_TotDeuda
				FROM INTEGRAGRUPOSCRE Ing,
					 SOLICITUDCREDITO Sol,
					 CREDITOS Cre
				WHERE Ing.GrupoID               = Par_GrupoID
				  AND Ing.Estatus               = Esta_Activo
				  AND Ing.ProrrateaPago         = Si_Prorratea
				  AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
				  AND Sol.CreditoID             = Cre.CreditoID
				  AND	(   Cre.Estatus		= Esta_Vigente
					   OR  Cre.Estatus		= Esta_Vencido	);
		ELSE
			SELECT  SUM(FUNCIONCONFINIQCRE(Cre.CreditoID)) INTO Mon_TotDeuda
				FROM `HIS-INTEGRAGRUPOSCRE` Ing,
					 SOLICITUDCREDITO Sol,
					 CREDITOS Cre
				WHERE Ing.GrupoID               = Par_GrupoID
				  AND Ing.Estatus               = Esta_Activo
				  AND Ing.ProrrateaPago         = Si_Prorratea
				  AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
				  AND Ing.Ciclo                 = Par_CicloGrupo
				  AND Sol.CreditoID             = Cre.CreditoID
				  AND	(   Cre.Estatus		= Esta_Vigente
					   OR  Cre.Estatus		= Esta_Vencido	);
		END IF;

		SET Mon_TotDeuda    := IFNULL(Mon_TotDeuda, Entero_Cero);

		SELECT  Mon_TotDeuda;

	END IF;


	IF(Par_NumCon = Con_CreIntegra) THEN

		SELECT CicloActual INTO Var_CicloActual
			FROM 	GRUPOSCREDITO
			WHERE GrupoID = Par_GrupoID;

		SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

		-- Verificamos el Ciclo del Grupo, Si es el Ciclo Actual o si es un Ciclo Anterior
		-- Entonces Buscamos los Integrantes en el Historico
		IF(Par_CicloGrupo = Var_CicloActual) THEN
			SELECT  Cre.CreditoID
				FROM INTEGRAGRUPOSCRE Ing,
					 SOLICITUDCREDITO Sol,
					 CREDITOS Cre
				WHERE Ing.GrupoID               = Par_GrupoID
				  AND Ing.Estatus               = Esta_Activo
				  AND Ing.ProrrateaPago         = Si_Prorratea
				  AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
				  AND Sol.CreditoID             = Cre.CreditoID
				  AND	(   Cre.Estatus		= Esta_Vigente
					   OR  Cre.Estatus		= Esta_Vencido
					   OR  Cre.Estatus		= Esta_Pagado);
		ELSE
			SELECT  Cre.CreditoID
				FROM `HIS-INTEGRAGRUPOSCRE` Ing,
					 SOLICITUDCREDITO Sol,
					 CREDITOS Cre
				WHERE Ing.GrupoID               = Par_GrupoID
				  AND Ing.Ciclo                = Par_CicloGrupo
				  AND Ing.Estatus               = Esta_Activo
				  AND Ing.ProrrateaPago         = Si_Prorratea
				  AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
				  AND Sol.CreditoID             = Cre.CreditoID
				  AND	(   Cre.Estatus		= Esta_Vigente
					   OR  Cre.Estatus		= Esta_Vencido
					   OR  Cre.Estatus		= Esta_Pagado);
		END IF;
	END IF;

	IF(Par_NumCon = Con_ValidaInt) THEN
		SELECT COUNT(GrupoID)
		FROM INTEGRAGRUPOSCRE
		WHERE GrupoID=Par_GrupoID;
	END IF;

	IF(Par_NumCon = Con_CicloGpo) THEN
		SELECT GrupoID, CicloActual
		FROM GRUPOSCREDITO
		WHERE GrupoID=Par_GrupoID;
	END IF;

	IF(Par_NumCon = Con_PerfilGpo) THEN

		SELECT Inte.ClienteID, Cli.PromotorActual, NombrePromotor
		INTO   Var_Cliente,    Var_PromotorAct,    Var_NombPromotor
		FROM INTEGRAGRUPOSCRE Inte
		INNER JOIN CLIENTES Cli ON Cli.ClienteID = Inte.ClienteID
		INNER JOIN PROMOTORES Prom ON Prom.PromotorID = Cli.PromotorActual
		WHERE GrupoID = Par_GrupoID
		  AND Cargo =   CargoPresidente;

		SET Var_Cliente		:=IFNULL(Var_Cliente,Entero_Cero);
		SET Var_PromotorAct	:=IFNULL(Var_PromotorAct,Entero_Cero);
		SET Var_NombPromotor	:=IFNULL(Var_NombPromotor,Cadena_Vacia);

		SELECT	Gpo.GrupoID,			Gpo.NombreGrupo,		DATE(Gpo.FechaRegistro) AS FechaRegistro,		Gpo.CicloActual,    Gpo.SucursalID,
				Suc.NombreSucurs,  	Gpo.EstatusCiclo,		Gpo.FechaUltCiclo,    						Var_PromotorAct,    Var_NombPromotor,
				Dir.DireccionCompleta
				FROM 	GRUPOSCREDITO Gpo
				INNER JOIN SUCURSALES Suc ON Suc.SucursalID= Gpo.SucursalID
				INNER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Var_Cliente
				WHERE	Gpo.GrupoID = Par_GrupoID
			   AND  Dir.Oficial = Si_DirEsOficial;
	END IF;


	IF(Par_NumCon = Con_IntGpo) THEN
		/*SELECT para consultar cuantos integrantes tiene un grupo por cliente*/
		SELECT		COUNT(Ing.SolicitudCreditoID) INTO 	Var_TotalIntegCte
			FROM	INTEGRAGRUPOSCRE Ing,
					CLIENTES Cli
			WHERE 	Ing.GrupoID		= Par_GrupoID
				AND Ing.ClienteID	= Cli.ClienteID;
		/*SELECT para consultar cuantos integrantes tiene un grupo por prospectos*/
		SELECT COUNT(Ing.SolicitudCreditoID) INTO Var_TotalIntegPros
			FROM	INTEGRAGRUPOSCRE Ing,
					PROSPECTOS P
			WHERE 	Ing.GrupoID		= Par_GrupoID
				AND Ing.ProspectoID = P.ProspectoID
				AND IFNULL(P.ClienteID,Entero_Cero)=Entero_Cero;

		SELECT (Var_TotalIntegCte+Var_TotalIntegPros)INTO 	Var_TotalInteg;

		/*SELECT para consultar cuantos integrantes mujeres tiene un grupo por cliente*/
		SELECT COUNT(Ing.ClienteID) INTO Var_TotaMujerCte
		FROM	CLIENTES Cli,
				INTEGRAGRUPOSCRE Ing
		WHERE	Ing.ClienteID			= Cli.ClienteID
			AND Cli.Sexo 				= Sex_F
			AND Cli.EstadoCivil			= EdoSoltero
			AND Ing.GrupoID             = Par_GrupoID;
		/*SELECT para consultar cuantos integrantes mujeres tiene un grupo por prospectos*/
		SELECT COUNT(Ing.ProspectoID) INTO Var_TotaMujerPros
		FROM	PROSPECTOS P,
				INTEGRAGRUPOSCRE Ing
		WHERE	Ing.ProspectoID			= P.ProspectoID
			AND P.Sexo 					= Sex_F
			AND P.EstadoCivil			= EdoSoltero
			AND Ing.GrupoID             = Par_GrupoID
			AND IFNULL(P.ClienteID,Entero_Cero)=Entero_Cero;
		SELECT (Var_TotaMujerCte+Var_TotaMujerPros)INTO Var_TotaMujerS;

		/*SELECT para consultar cuantos integrantes mujeres tiene un grupo por cliente*/
		SELECT  COUNT(Ing.ClienteID)  INTO Var_TotaMujerCtes
		FROM	INTEGRAGRUPOSCRE Ing,
				CLIENTES Cli
		WHERE  Ing.ClienteID			= Cli.ClienteID
			AND Cli.Sexo 				= Sex_F
			AND Ing.GrupoID             = Par_GrupoID;
		/*SELECT para consultar cuantos integrantes mujeres tiene un grupo por prospecto*/
		SELECT  COUNT(Ing.ProspectoID)  INTO Var_TotaMujerProsp
		FROM	INTEGRAGRUPOSCRE Ing,
				PROSPECTOS P
		WHERE  Ing.ProspectoID			= P.ProspectoID
			AND P.Sexo 					= Sex_F
			AND Ing.GrupoID             = Par_GrupoID
			AND IFNULL(P.ClienteID,Entero_Cero)=Entero_Cero;

		SELECT (Var_TotaMujerCtes + Var_TotaMujerProsp)INTO Var_TotaMujer;

		/*SELECT para consultar cuantos integrantes hombres tiene un grupo por cliente*/
		SELECT  COUNT(Ing.ClienteID)  INTO Var_TotaHombCte
		FROM	INTEGRAGRUPOSCRE Ing,
				CLIENTES Cli
		WHERE Ing.GrupoID               = Par_GrupoID
			AND Ing.ClienteID			= Cli.ClienteID
			AND Cli.Sexo 				= Sex_M;
		/*SELECT para consultar cuantos integrantes hombres tiene un grupo por prospectos*/
		SELECT  COUNT(Ing.ProspectoID)  INTO Var_TotaHombPros
		FROM	INTEGRAGRUPOSCRE Ing,
				PROSPECTOS P
		WHERE Ing.GrupoID               = Par_GrupoID
			AND Ing.ProspectoID			= P.ProspectoID
			AND P.Sexo 					= Sex_M
			AND IFNULL(P.ClienteID,Entero_Cero)=Entero_Cero;

		SELECT (Var_TotaHombCte+Var_TotaHombPros) INTO Var_TotaHomb;

		SET Var_TotalInteg		:= IFNULL(Var_TotalInteg, Entero_Cero);
		SET Var_TotaMujerS		:= IFNULL(Var_TotaMujerS, Entero_Cero);
		SET Var_TotaMujer		:= IFNULL(Var_TotaMujer, Entero_Cero);
		SET Var_TotaHomb		:= IFNULL(Var_TotaHomb, Entero_Cero);

		SELECT 	Var_TotalInteg,
				Var_TotaMujerS,
				Var_TotaMujer,
				Var_TotaHomb;

	END IF;

	/* Tipo de Consulta: Rompimiento Grupo */
	IF(Par_NumCon = Con_RompGrupo) THEN
		SELECT	Rmp.GrupoID,Gpo.NombreGrupo, Rmp.SucursalID, Rmp.UsuarioID
			FROM ROMPIMIENTOSGRUPO Rmp,
				GRUPOSCREDITO Gpo
				WHERE Gpo.GrupoID = Par_GrupoID
				AND Rmp.GrupoID=Gpo.GrupoID
			LIMIT 1;
	END IF;

	/* Tipo de Consulta: Grupo con Solicitud Liberada */
	IF(Par_NumCon = Con_SolLiberada) THEN
		SELECT  Pue.AtiendeSuc,         Usu.SucursalUSuario INTO
			Var_AtiendeSucursales,  Var_SucursalUsuario
			FROM USUARIOS Usu
				INNER JOIN PUESTOS Pue ON Pue.ClavePuestoID = Usu.ClavePuestoID
			WHERE Usu.UsuarioID = Aud_Usuario;

			SELECT DISTINCT Gpo.GrupoID,	Gpo.NombreGrupo, Gpo.CicloActual, Sol.Estatus,
					Sol.SucursalID, Var_SucursalUsuario AS SucursalPromotor,
					Var_AtiendeSucursales AS PromotAtiendeSucursal
			FROM GRUPOSCREDITO Gpo
				INNER JOIN SOLICITUDCREDITO Sol
					ON Gpo.GrupoID= Sol.GrupoID
				INNER JOIN INTEGRAGRUPOSCRE InG
					ON InG.SolicitudCreditoID= Sol.SolicitudCreditoID
						AND InG.GrupoID= Gpo.GrupoID
				INNER JOIN PRODUCTOSCREDITO Pro
					ON Sol.ProductoCreditoID= Pro.ProducCreditoID
				INNER JOIN SUCURSALES Suc
					ON Suc.SucursalID = Gpo.SucursalID
			WHERE Gpo.GrupoID = Par_GrupoID
				 AND Sol.Estatus = EstatLiberada
				 AND Gpo.EstatusCiclo = EstatAbierto;
	END IF;


	/* Tipo de Consulta: Consulta de pagare del Grupo */
	IF(Par_NumCon = Con_PagareGrupo) THEN
			-- Seteamos el Ciclo Actual del Grupo
		SELECT CicloActual INTO Var_CicloActual
		FROM 	GRUPOSCREDITO
		WHERE  	GrupoID = Par_GrupoID;

		SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

		SELECT Gpo.GrupoID,Cre.PagareImpreso
		FROM CREDITOS Cre
		LEFT JOIN GRUPOSCREDITO Gpo
		ON Gpo.GrupoID=Cre.GrupoID
		WHERE Gpo.GrupoID = Par_GrupoID
		AND Gpo.CicloActual = Var_CicloActual
	        AND Cre.CicloGrupo = Var_CicloActual
		LIMIT 1;
	 END IF;

	-- Tipo de Consulta: Consulta la existencia del Grupo, y el total de sus integrantes
	-- Utilizado en: * alta de solicitud de creditos via WS para SANA TUS FINANZAS
	-- No.Consulta: 14
	IF(Par_NumCon = Con_ExisteGrupo) THEN

		SELECT GrupoID INTO Var_GrupoID
			FROM GRUPOSCREDITO
				WHERE GrupoID = Par_GrupoID;

		IF(IFNULL(Var_GrupoID,Entero_Cero)=Entero_Cero)THEN
			SELECT Entero_Cero AS GrupoID, Entero_Cero AS TotalIntegrantes;
		ELSE
			SELECT IFNULL(GrupoID,Var_GrupoID) AS GrupoID, COUNT(GrupoID) AS TotalIntegrantes
				FROM INTEGRAGRUPOSCRE
					WHERE GrupoID = Var_GrupoID;
		END IF;

	END IF;

    IF(Par_NumCon = Con_Agropecuario) THEN
		IF(EXISTS (SELECT GrupoID FROM INTEGRAGRUPOSCRE WHERE GrupoID=Par_GrupoID))THEN

				SELECT DISTINCT Gpo.GrupoID,			Gpo.NombreGrupo,		DATE(Gpo.FechaRegistro) AS FechaRegistro,		Gpo.SucursalID,					Gpo.CicloActual,
						Gpo.EstatusCiclo,		Gpo.FechaUltCiclo, 		Pro.ProducCreditoID,							IFNULL(Suc.NombreSucurs, ""), 	Gpo.TipoOperaAgro
				FROM 	GRUPOSCREDITO Gpo
					INNER JOIN INTEGRAGRUPOSCRE InG ON Gpo.GrupoID= InG.GrupoID
					INNER JOIN SOLICITUDCREDITO Sol ON InG.SolicitudCreditoID= Sol.SolicitudCreditoID
					INNER JOIN PRODUCTOSCREDITO Pro ON Sol.ProductoCreditoID= Pro.ProducCreditoID
					INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Gpo.SucursalID
						WHERE  	Gpo.GrupoID = Par_GrupoID
							AND Gpo.EsAgropecuario = Es_Agropecuario;

		ELSE
				SELECT	Gpo.GrupoID,			Gpo.NombreGrupo,		Gpo.FechaRegistro,		Gpo.SucursalID,					Gpo.CicloActual,
						Gpo.EstatusCiclo,		Gpo.FechaUltCiclo, 		NULL, 					IFNULL(Suc.NombreSucurs, ""), 	Gpo.TipoOperaAgro
					FROM 	GRUPOSCREDITO Gpo,
							SUCURSALES Suc
						WHERE  	Gpo.GrupoID =Par_GrupoID
							AND Suc.SucursalID = Gpo.SucursalID
								AND Gpo.EsAgropecuario = Es_Agropecuario;
		END IF;
	END IF;


	IF(Par_NumCon = Con_DesembolsosGrup) THEN

		SELECT	Gpo.GrupoID,			Gpo.NombreGrupo,		 COUNT(Cre.CreditoID) AS NumCreditos
		FROM 	GRUPOSCREDITO Gpo
            LEFT JOIN CREDITOS Cre  ON Gpo.GrupoID = Cre.GrupoID
            AND Cre.FechaMinistrado = Var_FechaSistema
                        AND Cre.Estatus = Esta_Vigente
                        AND (Cre.FolioDispersion = Entero_Cero OR Cre.MontoDesemb = Cre.MontoCredito)
				WHERE  	Gpo.GrupoID = Par_GrupoID
						AND Gpo.EsAgropecuario = No_Es_Agropecuario
                        GROUP BY Gpo.GrupoID,	Gpo.NombreGrupo;

	END IF;

	-- 17: Consulta solicitudes de creditos con estatus inactivo
	IF(Par_NumCon = Con_GrupoInactiva) THEN
		SELECT  Pue.AtiendeSuc,         Usu.SucursalUSuario INTO
			Var_AtiendeSucursales,  Var_SucursalUsuario
			FROM USUARIOS Usu
				INNER JOIN PUESTOS Pue ON Pue.ClavePuestoID = Usu.ClavePuestoID
			WHERE Usu.UsuarioID = Aud_Usuario;

			SELECT DISTINCT Gpo.GrupoID,	Gpo.NombreGrupo, Gpo.CicloActual, Sol.Estatus,
					Sol.SucursalID, Var_SucursalUsuario AS SucursalPromotor,
					Var_AtiendeSucursales AS PromotAtiendeSucursal
			FROM GRUPOSCREDITO Gpo
				INNER JOIN SOLICITUDCREDITO Sol
					ON Gpo.GrupoID= Sol.GrupoID
				INNER JOIN INTEGRAGRUPOSCRE InG
					ON InG.SolicitudCreditoID= Sol.SolicitudCreditoID
						AND InG.GrupoID= Gpo.GrupoID
				INNER JOIN PRODUCTOSCREDITO Pro
					ON Sol.ProductoCreditoID= Pro.ProducCreditoID
				INNER JOIN SUCURSALES Suc
					ON Suc.SucursalID = Gpo.SucursalID
			WHERE Gpo.GrupoID = Par_GrupoID
				 AND Sol.Estatus = Est_Inactivo
				 AND Gpo.EstatusCiclo = EstatAbierto;
	END IF;

END TerminaStore$$