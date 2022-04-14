-- SP CONSTANCIARETCTERELLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS CONSTANCIARETCTERELLIS;

DELIMITER $$

CREATE PROCEDURE `CONSTANCIARETCTERELLIS`(
	-- Lista de informacion para la generacion de Constancias de Retencion de Relacionados Fiscales
	Par_AnioProceso 		INT(11),			-- Anio para generar Constancia Retencion
    Par_SucursalInicio		INT(11),			-- Sucursal de Inicio
	Par_SucursalFin			INT(11),			-- Sucursal de Fin
	Par_NombreComp		    VARCHAR(50),		-- Nombre Completo Cliente
    Par_ClienteID			INT(11),			-- Numero de Cliente

    Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista

	Par_EmpresaID			INT(11),			-- Parametro de Auditoria
	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria

)
TerminaStore:BEGIN
	-- Declaracion de Variables
	DECLARE Var_ConsecutivoID	INT(11);   		-- Variable consecutivo
	DECLARE Var_NumRegistros	INT(11);		-- Almacena el Numero de Registros
	DECLARE Var_Contador		INT(11);		-- Contador
	DECLARE Var_ContadorRel		INT(11);		-- Contador Relacionado
    DECLARE Var_ConstanciaRetID	BIGINT(12);		-- Numero Consecutivo Constancia de Retencion

    DECLARE Var_ClienteID 		INT(11);		-- Numero de Cliente
    DECLARE Var_SucursalID   	INT(11);		-- Numero de Sucursales
	DECLARE Var_Tipo			CHAR(2);		-- Tipo Relacionados Fiscales\nA = Aportante\nC = Cliente\nR = Relacionado\nAC = Aportante Cliente
	DECLARE Var_CteRelacionadoID INT(11);		-- Numero del Cliente relacionado o 0 si el relacionado no es Cliente
    DECLARE Var_ClienteAnt		INT(11);		-- Almacena el numero de Cliente Anterior

	DECLARE Var_RutaXML			VARCHAR(100);	-- Ruta para alojar el Archivo XML
	DECLARE Var_RutaCBB			VARCHAR(100);	-- Ruta para alojar el Archivo CBB

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Lis_Principal	INT(11);
	DECLARE Lis_Foranea		INT(11);

	DECLARE Lis_Rango		INT(11);
	DECLARE Lis_Cte			INT(11);
	DECLARE Lis_Sucursal	INT(11);
	DECLARE Lis_SucXML	    INT(11);
	DECLARE Lis_RangoMasivo	INT(11);

	DECLARE TipoAportante	CHAR(1);
    DECLARE TipoCliente		CHAR(1);
    DECLARE TipoRelacion	CHAR(1);
	DECLARE TipoAportaCte	CHAR(2);

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';				-- Cadena vacia
	SET	Fecha_Vacia		:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero		:= 0;				-- Entero Cero
	SET	Lis_Principal	:= 1;				-- Lista Principal
	SET	Lis_Foranea		:= 2;				-- Lista Foranea

	SET Lis_Rango		:= 3;				-- Lista de Rangos
    SET Lis_Cte			:= 4;				-- Lista de Clientes para el Timbrado
    SET Lis_Sucursal	:= 5;				-- Lista de Sucursales por Transaccion
	SET Lis_SucXML		:= 6;				-- Lista de Sucursales para la Lectura del XML
	SET Lis_RangoMasivo := 7;				-- Lista de Sucursales para constancias masivas

	SET TipoAportante	:= 'A';				-- Tipo Relacionado Fiscal: APORTANTE
    SET TipoCliente		:= 'C';				-- Tipo Relacionado Fiscal: CLIENTE
    SET TipoRelacion	:= 'R';				-- Tipo Relacionado Fiscal: RELACIONADO
	SET TipoAportaCte	:= 'AC';			-- Tipo Relacionado Fiscal: APORTANTE CLIENTE

	-- Se obtiene parametros CONSTANCIARETPARAMS
	SELECT RutaCFDI,		RutaCBB
	INTO   Var_RutaXML,		Var_RutaCBB
	FROM CONSTANCIARETPARAMS;

	SET Var_RutaXML 	:= IFNULL(Var_RutaXML, Cadena_Vacia);
	SET Var_RutaCBB 	:= IFNULL(Var_RutaCBB, Cadena_Vacia);

    -- 1.- Lista Principal
    IF(Par_NumLis = Lis_Principal)THEN
		-- Se elimina la tabla temporal
		DELETE FROM TMPCTERELTIMBRADO;
		SET @Var_ConsecutivoID := 0;

        INSERT INTO TMPCTERELTIMBRADO (
			ConsecutivoID,		ConstanciaRetID,	ClienteID,			SucursalID,		CadenaCFDI,
            Estatus,			Tipo,				CteRelacionadoID,	RutaXML,		RutaCBB,
            EmpresaID,			Usuario,			FechaActual,		DireccionIP,	ProgramaID,
            Sucursal,			NumTransaccion)
        SELECT
			@Var_ConsecutivoID:=@Var_ConsecutivoID+1,ConstanciaRetID,	ClienteID,			SucursalID,		CadenaCFDI,
            Estatus,			Tipo,				CteRelacionadoID,	Cadena_Vacia,		Cadena_Vacia,
            Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
            Aud_Sucursal,		Aud_NumTransaccion
        FROM CONSTANCIARETCTEREL
        WHERE Anio = Par_AnioProceso
		AND SucursalID BETWEEN Par_SucursalInicio AND Par_SucursalFin
        AND CadenaCFDI != Cadena_Vacia
        AND NumTransaccion = Aud_NumTransaccion;

		-- Se obtiene el numero de registros para actualizar el nombre del PDF
		SET Var_NumRegistros := (SELECT COUNT(ConsecutivoID) FROM TMPCTERELTIMBRADO);
		SET Var_NumRegistros := IFNULL(Var_NumRegistros,Entero_Cero);

		-- Se valida que el numero de registros para actualizar el nombre del PDF sea mayor a cero
		IF(Var_NumRegistros > Entero_Cero)THEN
             -- Se inicializa el Contador
			SET Var_Contador 		:= 1;
            SET Var_ContadorRel 	:= 1;

            -- Se actualiza el nombre del XML y el CBB
			WHILE(Var_Contador <= Var_NumRegistros) DO
				SELECT	ConstanciaRetID,		ClienteID,			SucursalID,			Tipo,			CteRelacionadoID
				INTO 	Var_ConstanciaRetID,	Var_ClienteID,		Var_SucursalID,		Var_Tipo,		Var_CteRelacionadoID
				FROM TMPCTERELTIMBRADO
				WHERE ConsecutivoID = Var_Contador;

				-- Se actualiza el nombre del XML y CBB cuando el Tipo Relacionado Fiscal sea Aportante
                IF(Var_Tipo = TipoAportante)THEN
					UPDATE TMPCTERELTIMBRADO
					SET RutaXML 	= CONCAT(Var_RutaXML, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso, '.xml'),
						RutaCBB 	= CONCAT(Var_RutaCBB, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso, '.png')
					WHERE ConsecutivoID = Var_Contador;
				END IF;

				-- Se actualiza el nombre del XML y CBB cuando el Tipo Relacionado Fiscal sea Cliente
				IF(Var_Tipo = TipoCliente)THEN
					UPDATE TMPCTERELTIMBRADO
					SET RutaXML 	= CONCAT(Var_RutaXML, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_CteRelacionadoID,CHAR), 10, 0),'-',Par_AnioProceso, '.xml'),
                        RutaCBB  	= CONCAT(Var_RutaCBB, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_CteRelacionadoID,CHAR), 10, 0),'-',Par_AnioProceso, '.png')
					WHERE ConsecutivoID = Var_Contador;
                END IF;

                -- Se actualiza el nombre del XML y CBB cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente) en los siguientes registros
				IF(Var_Tipo = TipoRelacion)THEN

					-- Se actualiza el nombre del XML y CBB cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente) en el primer registro
					IF(Var_Contador = 1)THEN
						UPDATE TMPCTERELTIMBRADO
						SET RutaXML 	= CONCAT(Var_RutaXML, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.xml'),
							RutaCBB 	= CONCAT(Var_RutaCBB, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.png')
						WHERE ConsecutivoID = Var_Contador;

						SET Var_ContadorRel:= Var_ContadorRel + 1;
					END IF;

					-- Se obtiene el numero del registro anterior cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente)
                    IF(Var_Contador > 1)THEN
						SELECT ClienteID INTO Var_ClienteAnt
						FROM TMPCTERELTIMBRADO
						WHERE ConsecutivoID = Var_Contador - 1;

						-- Si el Aportante Anterior es el mismo que el Aportante actual
						IF(Var_ClienteAnt = Var_ClienteID)THEN

							UPDATE TMPCTERELTIMBRADO
							SET RutaXML 	= CONCAT(Var_RutaXML, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.xml'),
								RutaCBB 	= CONCAT(Var_RutaCBB, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.png')
							WHERE ConsecutivoID = Var_Contador;

							SET Var_ContadorRel:= Var_ContadorRel + 1;
						END IF;

						-- Si el Aportante Anterior es diferente al Aportante actual
						IF(Var_ClienteAnt != Var_ClienteID)THEN

							SET Var_ContadorRel	:= 1;

							UPDATE TMPCTERELTIMBRADO
							SET RutaXML 	= CONCAT(Var_RutaXML, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.xml'),
								RutaCBB 	= CONCAT(Var_RutaCBB, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.png')
							WHERE ConsecutivoID = Var_Contador;

							SET Var_ContadorRel:= Var_ContadorRel + 1;
						END IF;
					END IF; -- FIN Se obtiene el numero del registro anterior cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente)
                END IF; -- FIN Se actualiza el nombre del XML y CBB cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente) en los siguientes registros

				SET Var_Contador := Var_Contador + 1;

            END WHILE; -- FIN del WHILE

		END IF;

		SELECT  ConstanciaRetID,	SucursalID,			ClienteID,  	CadenaCFDI,		Estatus,
				Tipo,				CteRelacionadoID,	RutaXML,		RutaCBB, 		Par_AnioProceso AS Anio
		FROM TMPCTERELTIMBRADO;

	END IF;

	-- 2.- Lista Foranea
	IF(Par_NumLis = Lis_Foranea )THEN
		-- Se elimina la tabla temporal
		DELETE FROM TMPCTERELTIMBRADO;
		SET @Var_ConsecutivoID := 0;

		INSERT INTO TMPCTERELTIMBRADO (
			ConsecutivoID,		ConstanciaRetID,	ClienteID,			SucursalID,		CadenaCFDI,
			Estatus,			Tipo,				CteRelacionadoID,	RutaXML,		RutaCBB,
			EmpresaID,			Usuario,			FechaActual,		DireccionIP,	ProgramaID,
			Sucursal,			NumTransaccion)
		SELECT
			@Var_ConsecutivoID:=@Var_ConsecutivoID+1,ConstanciaRetID,	ClienteID,			SucursalID,		Cadena_Vacia,
			Entero_Cero,		Tipo,				CteRelacionadoID,	Cadena_Vacia,		Cadena_Vacia,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion
		FROM CONSTANCIARETCTEREL
		WHERE Anio = Par_AnioProceso
		AND SucursalID BETWEEN Par_SucursalInicio AND Par_SucursalFin;

        -- Se obtiene el numero de registros para actualizar el nombre del PDF
		SET Var_NumRegistros := (SELECT COUNT(ConsecutivoID) FROM TMPCTERELTIMBRADO);
		SET Var_NumRegistros := IFNULL(Var_NumRegistros,Entero_Cero);

        -- Se valida que el numero de registros para actualizar el nombre del PDF sea mayor a cero
		IF(Var_NumRegistros > Entero_Cero)THEN
             -- Se inicializa el Contador
			SET Var_Contador 		:= 1;
            SET Var_ContadorRel 	:= 1;

            -- Se actualiza el nombre del XML
			WHILE(Var_Contador <= Var_NumRegistros) DO
				SELECT	ConstanciaRetID,		ClienteID,			SucursalID,			Tipo,			CteRelacionadoID
				INTO 	Var_ConstanciaRetID,	Var_ClienteID,		Var_SucursalID,		Var_Tipo,		Var_CteRelacionadoID
				FROM TMPCTERELTIMBRADO
				WHERE ConsecutivoID = Var_Contador;

				-- Se actualiza el nombre del XML cuando el Tipo Relacionado Fiscal sea Aportante
                IF(Var_Tipo = TipoAportante)THEN
					UPDATE TMPCTERELTIMBRADO
					SET RutaXML 	= CONCAT(Var_RutaXML, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso, '.xml')
					WHERE ConsecutivoID = Var_Contador;
				END IF;

				-- Se actualiza el nombre del XML cuando el Tipo Relacionado Fiscal sea Cliente
				IF(Var_Tipo = TipoCliente)THEN
					UPDATE TMPCTERELTIMBRADO
					SET RutaXML 	= CONCAT(Var_RutaXML, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_CteRelacionadoID,CHAR), 10, 0),'-',Par_AnioProceso, '.xml')
					WHERE ConsecutivoID = Var_Contador;
                END IF;

                -- Se actualiza el nombre del XML cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente) en los siguientes registros
				IF(Var_Tipo = TipoRelacion)THEN

					-- Se actualiza el nombre del XML cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente) en el primer registro
					IF(Var_Contador = 1)THEN
						UPDATE TMPCTERELTIMBRADO
						SET RutaXML 	= CONCAT(Var_RutaXML, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.xml')
						WHERE ConsecutivoID = Var_Contador;

						SET Var_ContadorRel:= Var_ContadorRel + 1;
					END IF;

					-- Se obtiene el numero del registro anterior cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente)
                    IF(Var_Contador > 1)THEN
						SELECT ClienteID INTO Var_ClienteAnt
						FROM TMPCTERELTIMBRADO
						WHERE ConsecutivoID = Var_Contador - 1;

						-- Si el Aportante Anterior es el mismo que el Aportante actual
						IF(Var_ClienteAnt = Var_ClienteID)THEN

							UPDATE TMPCTERELTIMBRADO
							SET RutaXML 	= CONCAT(Var_RutaXML, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.xml')
							WHERE ConsecutivoID = Var_Contador;

							SET Var_ContadorRel:= Var_ContadorRel + 1;
						END IF;

						-- Si el Aportante Anterior es diferente al Aportante actual
						IF(Var_ClienteAnt != Var_ClienteID)THEN

							SET Var_ContadorRel	:= 1;

							UPDATE TMPCTERELTIMBRADO
							SET RutaXML 	= CONCAT(Var_RutaXML, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.xml')
							WHERE ConsecutivoID = Var_Contador;

							SET Var_ContadorRel:= Var_ContadorRel + 1;
						END IF;
					END IF; -- FIN Se obtiene el numero del registro anterior cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente)
                END IF; -- FIN Se actualiza el nombre del XML cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente) en los siguientes registros

				SET Var_Contador := Var_Contador + 1;

            END WHILE; -- FIN del WHILE

		END IF;

		SELECT  ConstanciaRetID,	SucursalID,			ClienteID,  	RutaXML
		FROM TMPCTERELTIMBRADO;

	END IF;

	-- 3.- Lista de Rangos por Sucursales
	IF(Par_NumLis = Lis_Rango)THEN
		SELECT MIN(ClienteID) AS Minimo, MAX(ClienteID) AS Maximo, COUNT(ClienteID) AS NumRegistros
		FROM CONSTANCIARETCTEREL
		WHERE SucursalID BETWEEN Par_SucursalInicio AND Par_SucursalFin
        AND Anio = Par_AnioProceso
        AND NumTransaccion = Aud_NumTransaccion;
	END IF;

	-- 4.- Lista de Clientes para el Timbrado
	IF(Par_NumLis = Lis_Cte)THEN
		-- Se elimina la tabla temporal
		DELETE FROM TMPCTERELTIMBRADO;
		SET @Var_ConsecutivoID := 0;

        INSERT INTO TMPCTERELTIMBRADO (
			ConsecutivoID,		ConstanciaRetID,	ClienteID,			SucursalID,		CadenaCFDI,
            Estatus,			Tipo,				CteRelacionadoID,	RutaXML,		RutaCBB,
            EmpresaID,			Usuario,			FechaActual,		DireccionIP,	ProgramaID,
            Sucursal,			NumTransaccion)
        SELECT
			@Var_ConsecutivoID:=@Var_ConsecutivoID+1,ConstanciaRetID,	ClienteID,			SucursalID,		CadenaCFDI,
            Estatus,			Tipo,				CteRelacionadoID,	Cadena_Vacia,		Cadena_Vacia,
            Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
            Aud_Sucursal,		Aud_NumTransaccion
        FROM CONSTANCIARETCTEREL
        WHERE Anio = Par_AnioProceso
		AND SucursalID BETWEEN Par_SucursalInicio AND Par_SucursalFin
        AND CadenaCFDI != Cadena_Vacia
		AND NumTransaccion = Aud_NumTransaccion;

		-- Se obtiene el numero de registros para actualizar el nombre del PDF
		SET Var_NumRegistros := (SELECT COUNT(ConsecutivoID) FROM TMPCTERELTIMBRADO);
		SET Var_NumRegistros := IFNULL(Var_NumRegistros,Entero_Cero);

		-- Se valida que el numero de registros para actualizar el nombre del PDF sea mayor a cero
		IF(Var_NumRegistros > Entero_Cero)THEN
             -- Se inicializa el Contador
			SET Var_Contador 		:= 1;
            SET Var_ContadorRel 	:= 1;

            -- Se actualiza el nombre del XML y el CBB
			WHILE(Var_Contador <= Var_NumRegistros) DO
				SELECT	ConstanciaRetID,		ClienteID,			SucursalID,			Tipo,			CteRelacionadoID
				INTO 	Var_ConstanciaRetID,	Var_ClienteID,		Var_SucursalID,		Var_Tipo,		Var_CteRelacionadoID
				FROM TMPCTERELTIMBRADO
				WHERE ConsecutivoID = Var_Contador;

				-- Se actualiza el nombre del XML y el CBB cuando el Tipo Relacionado Fiscal sea Aportante
                IF(Var_Tipo = TipoAportante)THEN
					UPDATE TMPCTERELTIMBRADO
					SET RutaXML 	= CONCAT(Var_RutaXML, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso, '.xml'),
						RutaCBB 	= CONCAT(Var_RutaCBB, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso, '.png')
					WHERE ConsecutivoID = Var_Contador;
				END IF;

				-- Se actualiza el nombre del XML y CBB cuando el Tipo Relacionado Fiscal sea Cliente
				IF(Var_Tipo = TipoCliente)THEN
					UPDATE TMPCTERELTIMBRADO
					SET RutaXML 	= CONCAT(Var_RutaXML, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_CteRelacionadoID,CHAR), 10, 0),'-',Par_AnioProceso, '.xml'),
                        RutaCBB  	= CONCAT(Var_RutaCBB, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_CteRelacionadoID,CHAR), 10, 0),'-',Par_AnioProceso, '.png')
					WHERE ConsecutivoID = Var_Contador;
                END IF;

                -- Se actualiza el nombre del XML y CBB cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente) en los siguientes registros
				IF(Var_Tipo = TipoRelacion)THEN

					-- Se actualiza el nombre del XML y CBB cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente) en el primer registro
					IF(Var_Contador = 1)THEN
						UPDATE TMPCTERELTIMBRADO
						SET RutaXML 	= CONCAT(Var_RutaXML, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.xml'),
							RutaCBB 	= CONCAT(Var_RutaCBB, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.png')
						WHERE ConsecutivoID = Var_Contador;

						SET Var_ContadorRel:= Var_ContadorRel + 1;
					END IF;

					-- Se obtiene el numero del registro anterior cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente)
                    IF(Var_Contador > 1)THEN
						SELECT ClienteID INTO Var_ClienteAnt
						FROM TMPCTERELTIMBRADO
						WHERE ConsecutivoID = Var_Contador - 1;

						-- Si el Aportante Anterior es el mismo que el Aportante actual
						IF(Var_ClienteAnt = Var_ClienteID)THEN

							UPDATE TMPCTERELTIMBRADO
							SET RutaXML 	= CONCAT(Var_RutaXML, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.xml'),
								RutaCBB 	= CONCAT(Var_RutaCBB, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.png')
							WHERE ConsecutivoID = Var_Contador;

							SET Var_ContadorRel:= Var_ContadorRel + 1;
						END IF;

						-- Si el Aportante Anterior es diferente al Aportante actual
						IF(Var_ClienteAnt != Var_ClienteID)THEN

							SET Var_ContadorRel	:= 1;

							UPDATE TMPCTERELTIMBRADO
							SET RutaXML 	= CONCAT(Var_RutaXML, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.xml'),
								RutaCBB 	= CONCAT(Var_RutaCBB, Par_AnioProceso,'/', LPAD(CONVERT(Var_SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Var_ClienteID,CHAR), 10, 0),'-',Par_AnioProceso,'-REL',Var_ContadorRel, '.png')
							WHERE ConsecutivoID = Var_Contador;

							SET Var_ContadorRel:= Var_ContadorRel + 1;
						END IF;
					END IF; -- FIN Se obtiene el numero del registro anterior cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente)
                END IF; -- FIN Se actualiza el nombre del XML y CBB cuando el Tipo Relacionado Fiscal sea Relacionado (No es Cliente) en los siguientes registros

				SET Var_Contador := Var_Contador + 1;

            END WHILE; -- FIN del WHILE

		END IF;

		SELECT  ConstanciaRetID,	SucursalID,			ClienteID,  	CadenaCFDI,		Estatus,
				Tipo,				CteRelacionadoID,	RutaXML,		RutaCBB, 		Par_AnioProceso AS Anio
		FROM TMPCTERELTIMBRADO;
	END IF;

    -- 5.- Lista de Sucursales por Transaccion
    IF(Par_NumLis = Lis_Sucursal)THEN
		SELECT MIN(SucursalID) AS Minimo,MAX(SucursalID) AS Maximo
        FROM CONSTANCIARETCTEREL
        WHERE Anio = Par_AnioProceso
		AND NumTransaccion = Aud_NumTransaccion;
    END IF;

	-- 6.- Lista de Sucursales para la Lectura del XML
	IF(Par_NumLis = Lis_SucXML)THEN
		SELECT MIN(SucursalID) AS Minimo,MAX(SucursalID) AS Maximo
		FROM CONSTANCIARETCTEREL
		WHERE Anio = Par_AnioProceso;
	END IF;

	-- 7.- Lista de Sucursales para constancias masivas
	IF(Par_NumLis = Lis_RangoMasivo)THEN
		SELECT MIN(ClienteID) AS Minimo, MAX(ClienteID) AS Maximo, COUNT(ClienteID) AS NumRegistros
		FROM CONSTANCIARETCTEREL
		WHERE SucursalID BETWEEN Par_SucursalInicio AND Par_SucursalFin
        AND Anio = Par_AnioProceso;
	END IF;
END TerminaStore$$