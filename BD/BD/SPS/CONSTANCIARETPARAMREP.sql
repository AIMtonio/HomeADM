-- SP CONSTANCIARETPARAMREP
DELIMITER ;
DROP PROCEDURE IF EXISTS CONSTANCIARETPARAMREP;
DELIMITER $$

CREATE PROCEDURE `CONSTANCIARETPARAMREP`(
-- ----------------------------------------------------------------------- --
-- --- SP PARA GENERAR LOS REPORTES DE CONSTANCIA DE RETENCION EN PDF ---- --
-- --- LISTA DE TODOS LOS CLIENTES A LOS QUE SE LES GENERA LA CONSTANCIA-- --
-- ----------------------------------------------------------------------- --
    Par_AnioProceso			INT(11), 	-- Anio de Proceso Constancia de Retencion
    Par_SucursalIni			INT(11),  	-- Sucursal de Inicio
    Par_SucursalFin     	INT(11),  	-- Sucursal Fin
    Par_CliInicio      	 	INT(11),  	-- Cliente Inicio
    Par_CliFin          	INT(11),   	-- Cliente Final

    Par_EmpresaID       	INT(11),	-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),	-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,	-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),	-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  -- Parametro de auditoria Numero de la transaccion
)TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Anio     		INT(11);		-- Anio para generar la Constancia
	DECLARE Var_RutaReporte		VARCHAR(250);	-- Ruta en donde se encuentra el prpt (ConstanciaRetencion.prpt)
    DECLARE Var_RutaExpPDF		VARCHAR(250);	-- Ruta para alojar las Constancias de Retencion en PDF
    DECLARE Var_RutaLogo		VARCHAR(100);	-- Ruta en donde se encuentra el logo de la Institucion
    DECLARE Var_RutaCedula		VARCHAR(100);	-- Ruta en donde se encuentra la Cedula Fiscal

    DECLARE Var_InstitucionID   INT(11);      	-- Almacena el Numero de la Institucion
	DECLARE Var_NombreInst		VARCHAR(100);	-- Almacena el Nombre de la Institucion
    DECLARE Var_DirFiscal		VARCHAR(250);	-- Almacena la Direccion Fiscal de la Institucion
    DECLARE Var_RFCEmisor       VARCHAR(25);	-- Almacena el RFC de la Institucion
	DECLARE Var_CliProEsp   	INT(11);		-- Almacena el Numero de Cliente para Procesos Especificos

    DECLARE Var_ConsecutivoID	INT(11);   		-- Variable consecutivo
	DECLARE Var_NumRegistros	INT(11);		-- Almacena el Numero de Registros
	DECLARE Var_Contador		INT(11);		-- Contador
    DECLARE Var_ConstanciaRetID	BIGINT(12);		-- Numero Consecutivo Constancia de Retencion
	DECLARE Var_ClienteID 		INT(11);		-- Numero de Cliente

    DECLARE Var_SucursalID   	INT(11);		-- Numero de Sucursal
	DECLARE Var_Tipo			CHAR(2);		-- Tipo Relacionados Fiscales\nA = Aportante\nC = Cliente\nR = Relacionado\nAC = Aportante Cliente
	DECLARE Var_CteRelacionadoID INT(11);		-- Numero del Cliente relacionado o 0 si el relacionado no es Cliente
    DECLARE Var_ClienteAnt		INT(11);		-- Almacena el numero de Cliente Anterior
	DECLARE Var_ContadorRel		INT(11);		-- Contador Relacionado

	DECLARE Var_RutaCBB			VARCHAR(100);	-- Ruta para alojar el Archivo CBB

    DECLARE Var_GeneraConsRetPDF 	CHAR(1);		-- Parametro S=si genera la constancia para todos o N= solo los qu tienen ISR mayor  0

	-- Declaracion de constantes
	DECLARE Entero_Cero     	INT(11);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Con_CliProcEspe     VARCHAR(20);
	DECLARE NumClienteMexi		INT(11);
	DECLARE TipoAportante		CHAR(1);

    DECLARE TipoCliente			CHAR(1);
    DECLARE TipoRelacion		CHAR(1);
	DECLARE TipoAportaCte		CHAR(2);
    DECLARE Decimal_Cero		DECIMAL(12,2);
    DECLARE Cons_SI				CHAR(1);		-- Constante si

	-- Asignacion de constantes
	SET Entero_Cero     	:= 0; 		-- Entero Cero
	SET Cadena_Vacia		:= '';		-- Cadena Vacia
    SET Con_CliProcEspe     := 'CliProcEspecifico'; -- Llave Parametro para Procesos Especificos
	SET NumClienteMexi		:= 40;		-- Numero de Cliente para Mexi Procesos Especificos: 40
    SET TipoAportante		:= 'A';		-- Tipo Relacionado Fiscal: APORTANTE

    SET TipoCliente			:= 'C';		-- Tipo Relacionado Fiscal: CLIENTE
	SET TipoRelacion		:= 'R';		-- Tipo Relacionado Fiscal: RELACIONADO
	SET TipoAportaCte		:= 'AC';	-- Tipo Relacionado Fiscal: APORTANTE CLIENTE
    SET Decimal_Cero		:= 0.00;	-- Decimal Cero
    SET Cons_SI				:= 'S';

	-- Se obtiene el Numero de Cliente para Procesos Especificos
	SET Var_CliProEsp 	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_CliProcEspe);
	SET Var_CliProEsp 	:= IFNULL(Var_CliProEsp,Entero_Cero);

	-- Se obtiene el Numero de la Institucion
	SET Var_InstitucionID := (SELECT InstitucionID FROM PARAMETROSSIS LIMIT 1);
	SET Var_InstitucionID := IFNULL(Var_InstitucionID, Entero_Cero);

	-- Se obtiene parametros CONSTANCIARETPARAMS
	SELECT AnioProceso,		RutaReporte,		RutaExpPDF, 	RutaLogo,
		   RutaCedula,		RutaCBB,			GeneraConsRetPDF
		INTO	Var_Anio,		Var_RutaReporte,	Var_RutaExpPDF,	Var_RutaLogo,
				Var_RutaCedula,	Var_RutaCBB,		Var_GeneraConsRetPDF
	FROM CONSTANCIARETPARAMS;

	SET Var_Anio 			:= IFNULL(Var_Anio, Entero_Cero);
    SET Var_RutaReporte 	:= IFNULL(Var_RutaReporte, Cadena_Vacia);
    SET Var_RutaExpPDF 		:= IFNULL(Var_RutaExpPDF, Cadena_Vacia);
    SET Var_RutaLogo 		:= IFNULL(Var_RutaLogo, Cadena_Vacia);
	SET Var_RutaCBB 		:= IFNULL(Var_RutaCBB, Cadena_Vacia);

	SELECT Nombre,			DirFiscal,		RFC
	INTO   Var_NombreInst,  Var_DirFiscal,	Var_RFCEmisor
	FROM INSTITUCIONES WHERE InstitucionID = Var_InstitucionID;

	SET Var_NombreInst 		:= IFNULL(Var_NombreInst, Cadena_Vacia);
    SET Var_DirFiscal 		:= IFNULL(Var_DirFiscal, Cadena_Vacia);

    -- Se genera Constancia de Retencion para clientes diferente a MEXI
	IF(Var_CliProEsp != NumClienteMexi)THEN
		-- Se obtiene los datos de cliente para generar el reporte en PDF
		SELECT DISTINCT(ClienteID) AS ClienteID,Var_RutaReporte AS rptName,
			 CONCAT(Var_RutaExpPDF, Par_AnioProceso,'/', LPAD(CONVERT(SucursalID,CHAR), 3, 0) ,'/',
			 LPAD(CONVERT(ClienteID,CHAR), 10, 0),'-',Par_AnioProceso, '.pdf') AS outputFile, Par_AnioProceso AS Anio,
			 Var_NombreInst AS Nombre, Var_DirFiscal AS DirFiscal,Var_RutaLogo AS RutaLogo,Var_RutaCedula AS RutaCedula,
			 Var_RFCEmisor AS RFCInst, Entero_Cero AS ConstanciaRetID,	Cadena_Vacia AS Tipo,	Entero_Cero AS CteRelacionadoID,
             Cadena_Vacia AS RutaCBB
		  FROM  CONSTANCIARETCTE
		  WHERE SucursalID >= Par_SucursalIni
			AND SucursalID <= Par_SucursalFin
			AND ClienteID  BETWEEN Par_CliInicio AND Par_CliFin
			AND Anio = Par_AnioProceso
			AND IF(Var_GeneraConsRetPDF = Cons_SI,
				MontoTotRet >= Entero_Cero,
                MontoTotRet > Entero_Cero)
		  ORDER BY ClienteID ASC;
	END IF;

	-- Se genera Constancia de Retencion para MEXI -- ConstanciaRetID,  Tipo
	IF(Var_CliProEsp = NumClienteMexi)THEN
		-- Se elimina la tabla temporal
		DELETE FROM TMPCTERELFISCALPDF;
		SET @Var_ConsecutivoID := 0;

        INSERT INTO TMPCTERELFISCALPDF (
			ConsecutivoID,		ConstanciaRetID,	ClienteID,	SucursalID,		Tipo,
            CteRelacionadoID,	NombrePDF,			RutaCBB)
        SELECT
			@Var_ConsecutivoID:=@Var_ConsecutivoID+1,ConstanciaRetID,	ClienteID,	SucursalID,		Tipo,
            CteRelacionadoID,	Cadena_Vacia,		Cadena_Vacia
        FROM CONSTANCIARETCTEREL
        WHERE SucursalID >= Par_SucursalIni
        AND SucursalID <= Par_SucursalFin
		AND ClienteID BETWEEN Par_CliInicio AND Par_CliFin
        AND Anio = Par_AnioProceso
        AND (MontoTotGrav > Decimal_Cero OR MontoTotExent > Decimal_Cero)
		AND IF(Var_GeneraConsRetPDF = Cons_SI,
			MontoTotRet >= Entero_Cero,
            MontoTotRet > Entero_Cero)
        ORDER BY ClienteID ASC;

        -- Se obtiene el numero de registros para actualizar el nombre del PDF
		SET Var_NumRegistros := (SELECT COUNT(ConsecutivoID) FROM TMPCTERELFISCALPDF);
		SET Var_NumRegistros := IFNULL(Var_NumRegistros,Entero_Cero);

		-- Se valida que el numero de registros para actualizar el nombre del PDF sea mayor a cero
		IF(Var_NumRegistros > Entero_Cero)THEN
             -- Se inicializa el Contador
			SET Var_Contador 		:= 1;
            SET Var_ContadorRel 	:= 1;

			-- Se actualiza el nombre del PDF y la Ruta de Alojamiento del Archivo CBB
			WHILE(Var_Contador <= Var_NumRegistros) DO
				SELECT	ConstanciaRetID,		ClienteID,			SucursalID,			Tipo,			CteRelacionadoID
				INTO 	Var_ConstanciaRetID,	Var_ClienteID,		Var_SucursalID,		Var_Tipo,		Var_CteRelacionadoID
				FROM TMPCTERELFISCALPDF
				WHERE ConsecutivoID = Var_Contador;

                -- Se actualiza el nombre del PDF cuando el Tipo Relacionado Fiscal sea Aportante
                IF(Var_Tipo = TipoAportante)THEN
					UPDATE TMPCTERELFISCALPDF
					SET NombrePDF 	= CONCAT(Var_RutaExpPDF, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso, '.pdf'),
						RutaCBB 	= CONCAT(Var_RutaCBB, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso, '.png')
					WHERE ConsecutivoID = Var_Contador;
				END IF;

                -- Se actualiza el nombre del PDF cuando el Tipo Relacionado Fiscal sea Cliente
				IF(Var_Tipo = TipoCliente)THEN
					UPDATE TMPCTERELFISCALPDF
					SET NombrePDF 	= CONCAT(Var_RutaExpPDF, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_CteRelacionadoID,CHAR), 10, 0),'-',Par_AnioProceso, '.pdf'),
                        RutaCBB  	= CONCAT(Var_RutaCBB, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_CteRelacionadoID,CHAR), 10, 0),'-',Par_AnioProceso, '.png')
					WHERE ConsecutivoID = Var_Contador;
                END IF;

				-- Se actualiza el nombre del PDF cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente) en los siguientes registros
				IF(Var_Tipo = TipoRelacion)THEN

					-- Se actualiza el nombre del PDF cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente) en el primer registro
					IF(Var_Contador = 1)THEN
						UPDATE TMPCTERELFISCALPDF
						SET NombrePDF 	= CONCAT(Var_RutaExpPDF, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.pdf'),
							RutaCBB 	= CONCAT(Var_RutaCBB, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.png')
						WHERE ConsecutivoID = Var_Contador;

						SET Var_ContadorRel:= Var_ContadorRel + 1;
					END IF;

					-- Se obtiene el numero del registro anterior cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente)
                    IF(Var_Contador > 1)THEN
						SELECT ClienteID INTO Var_ClienteAnt
						FROM TMPCTERELFISCALPDF
						WHERE ConsecutivoID = Var_Contador - 1;

						-- Si el Aportante Anterior es el mismo que el Aportante actual
						IF(Var_ClienteAnt = Var_ClienteID)THEN

							UPDATE TMPCTERELFISCALPDF
							SET NombrePDF 	= CONCAT(Var_RutaExpPDF, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.pdf'),
								RutaCBB 	= CONCAT(Var_RutaCBB, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.png')
							WHERE ConsecutivoID = Var_Contador;

							SET Var_ContadorRel:= Var_ContadorRel + 1;
						END IF;

						-- Si el Aportante Anterior es diferente al Aportante actual
						IF(Var_ClienteAnt != Var_ClienteID)THEN

							SET Var_ContadorRel	:= 1;

							UPDATE TMPCTERELFISCALPDF
							SET NombrePDF 	= CONCAT(Var_RutaExpPDF, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.pdf'),
								RutaCBB 	= CONCAT(Var_RutaCBB, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.png')
							WHERE ConsecutivoID = Var_Contador;

							SET Var_ContadorRel:= Var_ContadorRel + 1;
						END IF;
					END IF; -- FIN Se obtiene el numero del registro anterior cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente)
                END IF; -- FIN Se actualiza el nombre del PDF cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente) en los siguientes registros

				SET Var_Contador := Var_Contador + 1;

			END WHILE; -- FIN del WHILE

        END IF; -- FIN Se valida que el numero de registros para actualizar el nombre del PDF sea mayor a cero

        SELECT 	ClienteID, 					Var_RutaReporte AS rptName, 	NombrePDF AS outputFile,	Par_AnioProceso AS Anio,
				Var_NombreInst AS Nombre, 	Var_DirFiscal AS DirFiscal,		Var_RutaLogo AS RutaLogo,	Var_RutaCedula AS RutaCedula,
				Var_RFCEmisor AS RFCInst,	ConstanciaRetID,				Tipo,						CteRelacionadoID,
                RutaCBB
		FROM TMPCTERELFISCALPDF;

    END IF;

END TerminaStore$$