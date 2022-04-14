-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONSULTADIOTREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONSULTADIOTREP`;
DELIMITER $$

CREATE PROCEDURE `CONSULTADIOTREP`(
/* SP QUE LISTA LOS REGISTROS DE LA DIOT */
	Par_Anio           	INT(11),				-- Año de Consulta
	Par_Mes				INT(11), 				-- Mes de Consulta
	Par_NumReporte     	TINYINT UNSIGNED,		-- Numero de Reporte

    Aud_Empresa         INT(11),				-- Parametro de Auditoria
    Aud_Usuario         INT(11),				-- Parametro de Auditoria
    Aud_FechaActual     DATETIME,				-- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),			-- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),			-- Parametro de Auditoria
    Aud_Sucursal        INT(11),				-- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)  			-- Parametro de Auditoria
    )
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaInicio		DATE;			# Almacena una fecha armada del parametros anio y mes
	DECLARE Var_FechaFin		DATE;			# Cierra el rango de fecha para la busqueda
    DECLARE Var_IVARetenidoID	INT(11);		# Impuesto que corresponde al IVA Retenido
    DECLARE Var_Sentencia		VARCHAR(10000);	# Sentecnia sql.
	DECLARE Var_NumClienteEsp	INT(11);		# Número de Cliente Especifico.

	-- Declaracion de Constantes
    DECLARE Cadena_Vacia    	CHAR(2);
    DECLARE Decimal_Cero		DECIMAL(4,2);
    DECLARE Entero_Cero			INT(11);
	DECLARE Rep_Excel       	INT(11);
	DECLARE Rep_CSV         	INT(11);

	DECLARE Var_FechaM      	INT(11);
	DECLARE Var_FechaI      	INT(11);
	DECLARE TipoExtranjero		CHAR(2);
	DECLARE TipoNacional		CHAR(2);
	DECLARE Est_Liquidada		CHAR(1);

	DECLARE Pers_Fisica			CHAR(1);
	DECLARE Pers_Moral			CHAR(1);
    DECLARE Const_SI			CHAR(1);
    DECLARE Const_NO			CHAR(1);
	DECLARE NumCliente_48		INT(11);

	SET Rep_Excel       		:= 1;			# Reporte Excel
	SET Rep_CSV         		:= 2;			# Reporte CSV
	SET Cadena_Vacia    		:= '';			# Cadena Vacia
	SET Decimal_Cero			:= 0.00;		# Decimal Cero
    SET Entero_Cero				:= 0;			# Entero Cero
	SET TipoExtranjero			:= '05';		# Valor Tipo Extranjero
	SET TipoNacional			:= '04';		# Valor Tipo Nacional
	SET Est_Liquidada			:= 'L';			# Estatus Liquidada
	SET Pers_Fisica				:= 'F';			# Persona Fisica
	SET Pers_Moral				:= 'M';			# Persona Moral
    SET Const_SI				:= 'S';			# Constante SI
    SET Const_NO				:= 'N';			# Constante NO
	SET NumCliente_48			:= 48;			# Número de Cliente Específico 48.

	# SE OBTIENE EL NÚM. DE CLIENTE ESPECÍFICO.
	SET Var_NumClienteEsp	:= TRIM(FNPARAMGENERALES('CliProcEspecifico'));
	SET Var_NumClienteEsp	:= IFNULL(Var_NumClienteEsp, Entero_Cero);

	SET Var_FechaInicio 	:= CONVERT(CONCAT(CONVERT(Par_Anio, CHAR), '-',CONVERT(Par_Mes, CHAR),'-', '1'), DATE);
	SET Var_FechaFin 		:= LAST_DAY(Var_FechaInicio);



	DROP TABLE IF EXISTS TMPDIOTREP;
	CREATE TEMPORARY TABLE TMPDIOTREP(
		FacturaProvID			INT(11),
		NoFactura				VARCHAR(20),
		ProveedorID				INT(11),
		TipoTerceroID			VARCHAR(2),
		TipoOperacionID			VARCHAR(2),

		RFC						CHAR(13),
		NumIDFiscal				VARCHAR(40),
		NomExtranjero			VARCHAR(150),
		PaisResidencia			VARCHAR(2),
		Nacionalidad			VARCHAR(20),

		ValActPagQuince			DECIMAL(14,2),
		ActosPagQuince			DECIMAL(14,2),
		MontoIVAPagQuince		DECIMAL(14,2),
		ValActPagDiez			DECIMAL(14,2),
		ActosPagDiez			DECIMAL(14,2),

		MontoIVAPagDiez			DECIMAL(14,2),
		ValActPagImpBienQuince	DECIMAL(14,2),
		MontoIVAImpQuince		DECIMAL(14,2),
		ValActPagImpBienDiez	DECIMAL(14,2),
		MontoIVAImpDiez			DECIMAL(14,2),

		ValActPagImpBienExentos	DECIMAL(14,2),
		ValActPagCeroIVA		DECIMAL(14,2),
		ValActPagSinIVA			DECIMAL(14,2),
		IVARetenido				DECIMAL(14,2),
		IVADevDescBon			DECIMAL(14,2),

		TotalGravable			DECIMAL(14,2),
		TotalFactura			DECIMAL(14,2),
		SubTotal				DECIMAL(14,2),
        Gravable				CHAR(1),
        GravaCero				CHAR(1),

		INDEX TMPDIOTREP_idx1(ProveedorID),
		INDEX TMPDIOTREP_idx2(TipoTerceroID),
		INDEX TMPDIOTREP_idx3(TipoOperacionID)

	);


	DROP TABLE IF EXISTS TMPIMPUESTOSDIOT;
	CREATE TEMPORARY TABLE TMPIMPUESTOSDIOT(
		NoFactura				VARCHAR(20),
		ProveedorID				INT(11),
		MontoIVARetenido		DECIMAL(14,2),

		INDEX TMPIMPUESTOSDIOT_idx1(NoFactura),
		INDEX TMPIMPUESTOSDIOT_idx2(ProveedorID)

	);


    DROP TABLE IF EXISTS TMPFACTURASPROV;
	CREATE TEMPORARY TABLE TMPFACTURASPROV(
		NoFactura				VARCHAR(20),
		ProveedorID				INT(11),

		INDEX TMPFACTURASPROV_idx1(NoFactura),
		INDEX TMPFACTURASPROV_idx2(ProveedorID)

	);

	SET Var_Sentencia:=Cadena_Vacia;
	-- Select para insertar los datos generales a la tabla
	SET Var_Sentencia:= CONCAT(Var_Sentencia,
		'INSERT INTO	TMPDIOTREP (',
			'FacturaProvID,				NoFactura,				ProveedorID,		TipoTerceroID,			TipoOperacionID, ',
			'RFC,						NumIDFiscal,			NomExtranjero,		PaisResidencia,			Nacionalidad, ',
			'ValActPagQuince,			ActosPagQuince,			MontoIVAPagQuince,	ValActPagDiez,			ActosPagDiez, ',
			'MontoIVAPagDiez,			ValActPagImpBienQuince,	MontoIVAImpQuince,	ValActPagImpBienDiez,	MontoIVAImpDiez, ',
			'ValActPagImpBienExentos,	ValActPagCeroIVA,		ValActPagSinIVA,	IVARetenido,			IVADevDescBon, ',
			'TotalGravable,				TotalFactura,			SubTotal,			Gravable,				GravaCero) ',
		'SELECT		F.FacturaProvID,	F.NoFactura,	IFNULL(P.ProveedorID, \'',Cadena_Vacia,'\') AS ProveedorID,	IFNULL(P.TipoTerceroID, \'',Cadena_Vacia,'\') AS TipoTercero,	IFNULL(P.TipoOperacionID, \'',Cadena_Vacia,'\') AS TipoOperacionID, ',
					'CASE ',
						'WHEN	P.TipoPersona = \'',Pers_Moral,'\'	THEN IFNULL(P.RFCpm,\'',Cadena_Vacia,'\') ',
						'WHEN	P.TipoPersona = \'',Pers_Fisica,'\' THEN IFNULL(P.RFC,\'',Cadena_Vacia,'\') ',
						'ELSE	\'',Cadena_Vacia,'\' ',
					'END AS RFC, ',
					'CASE P.TipoTerceroID ',
						'WHEN	\'',TipoExtranjero,'\' THEN IFNULL(P.NumIDFIscal,\'',Cadena_Vacia,'\') ',
						'ELSE	\'',Cadena_Vacia,'\' ',
					'END AS NumIDFiscal, ',
					'CASE P.TipoTerceroID ',
						'WHEN	\'',TipoExtranjero,'\' THEN IFNULL(P.RazonSocial,\'',Cadena_Vacia,'\') ',
						'ELSE 	\'',Cadena_Vacia,'\' ',
					'END AS NomExtranjero, ',
					'CASE P.TipoTerceroID ',
						'WHEN	\'',TipoExtranjero,'\' THEN IFNULL(P.PaisID, \'',Cadena_Vacia,'\') ',
						'ELSE 	\'',Cadena_Vacia,'\' ',
					'END AS PaisResidencia, ',
					 'CASE P.TipoTerceroID ',
						'WHEN	\'',TipoExtranjero,'\' THEN IFNULL(P.Nacionalidad, \'',Cadena_Vacia,'\') ',
						'ELSE  	\'',Cadena_Vacia,'\' ',
					'END AS Nacionalidad, ',
					'SUM(D.Importe),		',Decimal_Cero,',		',Decimal_Cero,',	',Decimal_Cero,',		',Decimal_Cero,', ',
                    '',Decimal_Cero,',		',Decimal_Cero,',		',Decimal_Cero,',	',Decimal_Cero,',	',Decimal_Cero,', ',
                    '',Decimal_Cero,',		',Decimal_Cero,',		',Decimal_Cero,',	',Decimal_Cero,',	',Decimal_Cero,', ',
                    'F.TotalGravable,	F.TotalFactura,		F.SubTotal,		D.Gravable,		D.GravaCero ',
			'FROM	PROVEEDORES P ',
					'LEFT JOIN FACTURAPROV F ON P.ProveedorID = F.ProveedorID ',
                    'LEFT JOIN DETALLEFACTPROV D	ON P.ProveedorID = F.ProveedorID ',
												'AND F.ProveedorID = D.ProveedorID ',
												'AND F.NoFactura = D.NoFactura ',
					'LEFT JOIN CATTIPOTERCERODIOT Ct	ON P.TipoTerceroID = Ct.Clave ',
					'LEFT JOIN CATTIPOOPERACIONDIOT T ON P.TipoOperacionID = T.Clave ',
					'LEFT JOIN CATPAISESDIOT Cp  ON P.PaisID = Cp.Clave ',
             'WHERE	',IF(Var_NumClienteEsp = NumCliente_48,'F.FechaProgPago','F.FechaFactura'),' BETWEEN \'',Var_FechaInicio,'\' AND \'',Var_FechaFin,'\' ',
             	'AND F.Estatus = \'',Est_Liquidada,'\' AND F.SaldoFactura = ',Decimal_Cero,' ',
             'GROUP BY D.ProveedorID, 	D.NoFactura,	D.Gravable, 		D.GravaCero,		F.FacturaProvID, ',
					  'F.NoFactura,		P.ProveedorID,	P.TipoTerceroID,	P.TipoOperacionID,	P.TipoPersona, ',
					  'F.TotalGravable,	F.TotalFactura,	F.SubTotal; ');

	SET @Sentencia	:= (Var_Sentencia);
	# EJECUCIÓN DE LA SENTENCIA SQL.
	PREPARE ST_REPORTE_DIOT FROM @Sentencia;
	EXECUTE ST_REPORTE_DIOT ;
	DEALLOCATE PREPARE ST_REPORTE_DIOT;

   -- Se insertan las facturas de los proveedores que tuvieron movimientos en un periodo de tiempo
	INSERT INTO TMPFACTURASPROV
		SELECT  DISTINCT NoFactura, ProveedorID  FROM TMPDIOTREP;

        -- Se obtiene el Impuesto al que corresponde el IVA Retenido
		SET Var_IVARetenidoID := (SELECT RetIVA FROM  PARAMETROSDIOT LIMIT 1);

		-- Se calcula el monto del impuesto por proveedor
		INSERT INTO TMPIMPUESTOSDIOT
			SELECT	T.NoFactura, T.ProveedorID,  SUM(D.ImporteImpuesto)
				FROM	TMPFACTURASPROV T
					INNER JOIN DETALLEIMPFACT D ON T.ProveedorID = D.ProveedorID
					AND T.NoFactura	= D.NoFactura
				WHERE	D.ImpuestoID =  Var_IVARetenidoID
				GROUP BY T.ProveedorID, T.NoFactura;

        -- Se actualiza el campo ValActPagCeroIVA para los detalles de facturas que gravan en 0%
		UPDATE	TMPDIOTREP
				SET ValActPagCeroIVA	= ValActPagQuince,
					ValActPagQuince 	= Decimal_Cero
			WHERE Gravable	= Const_SI AND  GravaCero = Const_SI;

        -- Se actualiza el campo ValActPagSinIVA para los detalles de facturas que no gravan
		UPDATE	TMPDIOTREP
				SET ValActPagSinIVA		= ValActPagQuince,
					ValActPagQuince 	= Decimal_Cero
			WHERE Gravable	= Const_NO AND  GravaCero = Const_NO;

        -- Se actualiza el campo IVARetenido
		UPDATE	TMPDIOTREP T1, TMPIMPUESTOSDIOT T2
				SET T1.IVARetenido	= T2.MontoIVARetenido
			WHERE	T1.ProveedorID	= T2.ProveedorID
            AND		T1.NoFactura	= T2.NoFactura;

	-- Sección que genera el reporte en excel
	IF(Par_NumReporte = Rep_Excel) THEN

		SELECT	ProveedorID,	TipoTerceroID AS TipoTercero,	TipoOperacionID,	RFC,	NumIDFiscal,
				NomExtranjero,	PaisResidencia,					Nacionalidad,
                SUM(ValActPagQuince) AS ValActPagQuince,
                SUM(ActosPagQuince) AS ActosPagQuince,
				SUM(IFNULL(MontoIVAPagQuince,Decimal_Cero)) AS MontoIVAPagQuince,
                SUM(ValActPagDiez) AS ValActPagDiez,
                SUM(ActosPagDiez) AS ActosPagDiez,
                SUM(MontoIVAPagDiez) AS MontoIVAPagDiez,
                SUM(ValActPagImpBienQuince) AS ValActPagImpBienQuince,
				SUM(MontoIVAImpQuince) AS MontoIVAImpQuince,
                SUM(ValActPagImpBienDiez) AS ValActPagImpBienDiez,
                SUM(MontoIVAImpDiez) AS MontoIVAImpDiez,
                SUM(ValActPagImpBienExentos) AS ValActPagImpBienExentos,
                SUM(ValActPagCeroIVA) AS ValActPagCeroIVA,
				SUM(ValActPagSinIVA) AS ValActPagSinIVA,
                (IVARetenido) AS IVARetenido,
                SUM(IVADevDescBon) AS IVADevDescBon
		FROM TMPDIOTREP
		GROUP BY ProveedorID,	TipoTerceroID,	TipoOperacionID,	RFC,		NumIDFiscal,
				 NomExtranjero,	PaisResidencia,	Nacionalidad,		IVARetenido;



	END IF;

	IF(Par_NumReporte = Rep_CSV) THEN
		SELECT CONCAT(TipOTerceroID,"|", TipoOperacionID,"|", RFC ,"|",NumIDFiscal,"|",
				NomExtranjero,"|", PaisResidencia,"|",Nacionalidad,"|",
				CASE
					WHEN IFNULL(ROUND(SUM(ValActPagQuince)), Entero_Cero) = Entero_Cero THEN Cadena_Vacia
					ELSE ROUND(SUM(ValActPagQuince))
				END,"|",
				Cadena_Vacia,"|",
				Cadena_Vacia,"|",
				Cadena_Vacia,"|",
				Cadena_Vacia,"|",
				Cadena_Vacia,"|",
				Cadena_Vacia,"|",
				Cadena_Vacia,"|",
				Cadena_Vacia,"|",
				Cadena_Vacia,"|",
				Cadena_Vacia,"|",
				CASE
					WHEN IFNULL(ROUND(SUM(ValActPagCeroIVA)), Entero_Cero) = Entero_Cero THEN Cadena_Vacia
					ELSE ROUND(SUM(ValActPagCeroIVA))
				END,"|",
				 CASE
					WHEN IFNULL(ROUND(SUM(ValActPagSinIVA)), Entero_Cero) = Entero_Cero THEN Cadena_Vacia
					ELSE ROUND(SUM(ValActPagSinIVA))
				END,"|",
				CASE
					WHEN IFNULL(IvaRetenido, Decimal_Cero) = Decimal_Cero THEN Cadena_Vacia
					ELSE ROUND(IFNULL(IVARetenido,Decimal_Cero)) END,"|",
				Cadena_Vacia,"|") AS Valor
			   FROM TMPDIOTREP
			GROUP BY ProveedorID,	TipOTerceroID,	TipoOperacionID,	RFC,		NumIDFiscal,
					 NomExtranjero,	PaisResidencia,	Nacionalidad,		IVARetenido;

	END IF;

END TerminaStore$$