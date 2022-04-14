-- SP TMPPROCDOMICILIAPAGOSLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS TMPPROCDOMICILIAPAGOSLIS;

DELIMITER $$

CREATE PROCEDURE `TMPPROCDOMICILIAPAGOSLIS`(
# =======================================================================
# ----- STORE PARA LA LISTA DE DOMICILIACION DE PAGOS PARA PROCESAR -----
# =======================================================================
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
    DECLARE Var_NombreCompleto  	VARCHAR(200);	-- Nombre Completo
    DECLARE Var_NombreInstitucion	VARCHAR(45);	-- Nombre Institucion

	-- Declaracion de Constantes
	DECLARE Entero_Cero    		INT(11);
	DECLARE Cadena_Vacia   	 	CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE ClaveExitosa		CHAR(2);
    DECLARE EstatusValido		VARCHAR(10);
    
    DECLARE EstatusFallido		VARCHAR(10);
    DECLARE TipoDomiciliacion	CHAR(1);
	DECLARE TipoAmbas			CHAR(1);

	DECLARE Lis_PorProcesar		INT(11);

	-- Asignacion de Constantes
	SET Entero_Cero				:= 0; 				-- Entero Cero
	SET Cadena_Vacia			:= '';   			-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';  	-- Fecha Vacia
    SET ClaveExitosa			:= '00';			-- Clave Exitosa
    SET EstatusValido			:= 'VALIDO';		-- Estatus: VALIDO
    
    SET EstatusFallido			:= 'FALLIDO';		-- Estatus: FALLIDO
    SET TipoDomiciliacion		:= 'D'; 			-- Tipo Codigo: Domiciliacion
	SET TipoAmbas				:= 'A'; 			-- Tipo Codigo: Ambas

	SET Lis_PorProcesar			:= 1;				-- Lista de Domiciliaciones de Pagos por Procesar

	-- 1.- Lista de Afiliaciones por Procesar
	IF(Par_NumLis = Lis_PorProcesar)THEN

        -- Tabla temporal para obtener los registros de los creditos al Importar el Layout de Domiciliacion de Pagos
		DROP TEMPORARY TABLE IF EXISTS TMPREGISTROSCREDITOS;
        CREATE TEMPORARY TABLE TMPREGISTROSCREDITOS(
			CreditoID 			BIGINT(12) 		NOT NULL 		COMMENT 'ID Credito',
			NumRegistros 		INT(11)			DEFAULT NULL 	COMMENT 'Numero Registros',
            NumExitosos 		INT(11)			DEFAULT NULL 	COMMENT 'Numero Claves Exitosos',
            NumErroneos 		INT(11)			DEFAULT NULL 	COMMENT 'Numero Claves Erroneos',
            PRIMARY KEY (CreditoID));

        INSERT INTO TMPREGISTROSCREDITOS(
			CreditoID,		NumRegistros,		NumExitosos,	NumErroneos)
        SELECT
			MAX(CreditoID), COUNT(CreditoID),	Entero_Cero,	Entero_Cero
		FROM TMPPROCDOMICILIAPAGOS
        WHERE Usuario = Aud_Usuario
        GROUP BY CreditoID;

		-- Tabla temporal para obtener los registros exitosos de los creditos al Importar el Layout de Domiciliacion de Pagos
        DROP TEMPORARY TABLE IF EXISTS TMPREGISTROSEXITOSOS;
        CREATE TEMPORARY TABLE TMPREGISTROSEXITOSOS(
			CreditoID 			BIGINT(12) 		NOT NULL 		COMMENT 'ID Credito',
			NumExitosos 		INT(11)			DEFAULT NULL 	COMMENT 'Numero Claves Exitosos',
            PRIMARY KEY (CreditoID));

        INSERT INTO TMPREGISTROSEXITOSOS(
			CreditoID,		NumExitosos)
        SELECT
			MAX(CreditoID), COUNT(ClaveDomicilia)
		FROM TMPPROCDOMICILIAPAGOS
        WHERE ClaveDomicilia = ClaveExitosa
        AND Usuario = Aud_Usuario
        GROUP BY CreditoID;

       -- Se actulizan los registros exitosos
       UPDATE TMPREGISTROSCREDITOS Tmp1,
			  TMPREGISTROSEXITOSOS Tmp2
       SET Tmp1.NumExitosos = Tmp2.NumExitosos
       WHERE Tmp1.CreditoID = Tmp2.CreditoID;

       -- Tabla temporal para obtener los registros erroneos de los creditos al Importar el Layout de Domiciliacion de Pagos
        DROP TEMPORARY TABLE IF EXISTS TMPREGISTROSERRONEOS;
        CREATE TEMPORARY TABLE TMPREGISTROSERRONEOS(
			CreditoID 			BIGINT(12) 		NOT NULL 		COMMENT 'ID Credito',
			NumErroneos 		INT(11)			DEFAULT NULL 	COMMENT 'Numero Claves Exitosos',
            PRIMARY KEY (CreditoID));

        INSERT INTO TMPREGISTROSERRONEOS(
			CreditoID,		NumErroneos)
        SELECT
			MAX(CreditoID), COUNT(ClaveDomicilia)
		FROM TMPPROCDOMICILIAPAGOS
        WHERE ClaveDomicilia <> ClaveExitosa
		AND Usuario = Aud_Usuario
        GROUP BY CreditoID;

        -- Se actulizan los registros erroneos
		UPDATE TMPREGISTROSCREDITOS Tmp1,
			  TMPREGISTROSERRONEOS Tmp2
		SET Tmp1.NumErroneos = Tmp2.NumErroneos
		WHERE Tmp1.CreditoID = Tmp2.CreditoID;

	   -- Se obtiene la informacion para mostrarlo en el grid de la pantalla Procesa Domiciliacion de Pagos despues de Importar el Layout de Domiciliacion de Pagos
       SELECT
			MAX(Tmp1.FolioID) AS FolioID, 			MAX(Tmp1.ClienteID) AS ClienteID,		MAX(Cli.NombreCompleto) AS NombreCliente,	MAX(Ins.InstitucionID) AS InstitucionID, 	UPPER(MAX(Ins.NombreCorto)) AS NombreInstitucion,
            MAX(Tmp1.CuentaClabe) AS CuentaClabe, 	MAX(Tmp1.CreditoID) AS CreditoID, 		SUM(Tmp1.MontoTotal) AS MontoTotal, 		SUM(Tmp1.MontoPendiente) AS MontoPendiente, SUM(Tmp1.MontoTotal - Tmp1.MontoPendiente) AS MontoAplicado,
            CASE WHEN MAX(Tmp2.NumRegistros) = MAX(Tmp2.NumErroneos) THEN EstatusFallido ELSE EstatusValido END AS Estatus,
			CASE WHEN MAX(Tmp2.NumRegistros) = MAX(Tmp2.NumErroneos) THEN MAX(Cat.Descripcion) ELSE Cadena_Vacia END AS Comentario,
            CASE WHEN MAX(Tmp2.NumRegistros) = MAX(Tmp2.NumErroneos) THEN MAX(ClaveDomicilia) ELSE ClaveExitosa END AS  ClaveDomicilia
		FROM TMPPROCDOMICILIAPAGOS Tmp1,
			 TMPREGISTROSCREDITOS Tmp2,
             CLIENTES Cli,
             INSTITUCIONES Ins,
             CATCODIGOSAFILIADOM Cat
        WHERE Tmp1.CreditoID = Tmp2.CreditoID
        AND Tmp1.ClienteID = Cli.ClienteID
        AND Tmp1.InstitucionID = Ins.InstitucionID
        AND Tmp1.ClaveDomicilia = Cat.ClaveCodigo
		AND Tmp1.Usuario = Aud_Usuario
        AND Cat.TipoCodigo IN(TipoDomiciliacion,TipoAmbas)
        GROUP BY Tmp1.CreditoID;

	END IF;


END TerminaStore$$