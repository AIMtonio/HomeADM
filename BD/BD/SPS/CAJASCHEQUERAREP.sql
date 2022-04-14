-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASCHEQUERAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASCHEQUERAREP`;DELIMITER $$

CREATE PROCEDURE `CAJASCHEQUERAREP`(
# ====================================================================
# ----- SP PARA GENERAR REPORTE DE CHEQUES EMITIDOS A UTILIZAR -------
# ====================================================================
	Par_InstitucionID 	INT(11),		-- Numero de la institucion bancaria
    Par_NumCtaInstit	VARCHAR(20),	-- Numero de la cuenta bancaria
    Par_SucursalID		INT(11),		-- Numero de la sucursal
    Par_TipoReporte		INT(11),		-- Numero del tipo de reporte
    Par_FechaInicio		DATE,			-- Fecha de inicio de la asignacion de chequera
    Par_FechaFinal		DATE,			-- Fecha final de la asignacion de chequera
    Par_TipoChequera	CHAR(2),		-- Tipo de chequera A - todas, P-proforma E- chequera

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT(11);
	DECLARE	Entero_Uno				INT(11);
	DECLARE Separador				CHAR(5);
	DECLARE Tip_ReportePrincipal	INT(11);
	DECLARE EstatusAsignada			CHAR(1);
	DECLARE ConChequera				CHAR(1);
	DECLARE TipCheq_Proforma		CHAR(1);
    DECLARE TipCheq_Estandar		CHAR(1);
    DECLARE TipCheq_Ambas			CHAR(1);
	DECLARE Var_Sentencia			VARCHAR(6000);

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;				-- Entero cero
	SET Entero_Uno					:= 1;				-- Entero uno
	SET Fecha_Vacia					:= '1900-01-01';	-- Fecha vacia
	SET Cadena_Vacia				:= '';				-- Cadena vacia
	SET Separador					:= ' - ';			-- Guion medio que se usa como separador
	SET Tip_ReportePrincipal 		:= 1;				-- Tipo de reporte principal PDF
	SET EstatusAsignada				:= 'A';				-- Estatus de la chequera Asignada
	SET ConChequera					:= 'S';				-- Si cuenta con chequera
	SET TipCheq_Proforma			:= 'P';				-- Tipo chequera proforma
    SET TipCheq_Estandar			:= 'E';				-- Tipo chequera estandar
    SET TipCheq_Ambas				:= 'A';				-- Tipo Chequera Ambas

	/* Tipo de Reporte principal*/
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=Tip_ReportePrincipal)THEN
		-- Tabla temporal que se usa para obtener los datos del reporte
		DROP TABLE IF EXISTS TMPASIGNACHEQUES;
		CREATE TEMPORARY TABLE TMPASIGNACHEQUES(
			InstitucionID 			INT(11),
			NombreCortoInst			VARCHAR(120),
			NumCtaInstit			VARCHAR(20),
			SucursalID				INT(11),
			NombreSucurs			VARCHAR(50),
			CajaID					INT(11),
			DescripcionCaja			VARCHAR(100),
			FolioCheqInicial 		BIGINT(20),
			FolioCheqFinal 			BIGINT(20),
			UltimoFolioUtilizado 	BIGINT(20),
			TotFoliosUsados 		BIGINT(20),
			FoliosRestantes 		BIGINT(20),
			FechaDotacion			DATE,
			UsuarioDota				VARCHAR(45),
            TipoChequera			CHAR(2),
			INDEX(InstitucionID,NumCtaInstit,SucursalID,CajaID,TipoChequera)
		);

		-- Tabla temporal para contar el numero total de cheques usados por las cajas
		DROP TABLE IF EXISTS TMPCHEQUESEMI;
		CREATE TEMPORARY TABLE TMPCHEQUESEMI(
			InstitucionID 			INT(11),
			NumCtaInstit			VARCHAR(20),
			SucursalID				INT(11),
			CajaID					INT(11),
			TotFoliosUsados 		BIGINT(20),
            TipoChequera			CHAR(2),
			INDEX(InstitucionID,NumCtaInstit,SucursalID,CajaID,TipoChequera)
		);

		-- Inicia el armado de la consulta para el reporte
		SET Var_Sentencia := CONCAT('INSERT INTO TMPASIGNACHEQUES(InstitucionID,NombreCortoInst,NumCtaInstit,SucursalID,NombreSucurs,CajaID,DescripcionCaja,FolioCheqInicial,FolioCheqFinal,',
									'UltimoFolioUtilizado,FechaDotacion,UsuarioDota,TipoChequera)');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' SELECT DISTINCT IT.InstitucionID,UPPER(CONCAT(IT.InstitucionID, \' - \',IT.NombreCorto)), CC.NumCtaInstit,');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' SU.SucursalID,SU.NombreSucurs, CC.CajaID, UPPER(CC.DescripcionCaja), CC.FolioCheqInicial,');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' CC.FolioCheqFinal, CASE WHEN(CC.FolioUtilizar)>',Entero_Cero,' THEN CC.FolioUtilizar ELSE ',Entero_Cero,' END UltimoFolioUtilizado,');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' DATE(CC.FechaActEstatus) FechaDotacion, UPPER(US.Clave) UsuarioDota,CC.TipoChequera');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' FROM CAJASCHEQUERA CC INNER JOIN INSTITUCIONES IT ON CC.InstitucionID = IT.InstitucionID');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CUENTASAHOTESO CA ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' ON IT.InstitucionID = CA.InstitucionID AND CC.NumCtaInstit =CA.NumCtaInstit');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN SUCURSALES SU ON CC.SucursalID = SU.SucursalID');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN USUARIOS US ON CC.Usuario=US.UsuarioID');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE CC.Estatus = \'',EstatusAsignada,'\'');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND CA.Estatus = \'',EstatusAsignada,'\'');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND CA.Chequera = \'',ConChequera,'\'');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND DATE(CC.FechaActEstatus) BETWEEN  \'',Par_FechaInicio,'\' AND \'',Par_FechaFinal,'\'');

		-- Filtro por institucion bancaria cuando sea diferente de cero
		IF(IFNULL(Par_InstitucionID, Entero_Cero)!=Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND   IT.InstitucionID = ',Par_InstitucionID);
		END IF;

		-- Filtro por numero de cuenta bancaria cuando sea diferente de cero
		IF(IFNULL(Par_NumCtaInstit, Entero_Cero)!=Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND CC.NumCtaInstit = ',Par_NumCtaInstit);
		END IF;

        -- Filtro por tipo de chequera
		IF(Par_TipoChequera != Cadena_Vacia) THEN
			IF(Par_TipoChequera = TipCheq_Ambas) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND (CC.TipoChequera = "',TipCheq_Proforma,'" OR CC.TipoChequera = "',TipCheq_Estandar,'")');

			ELSEIF(Par_TipoChequera = TipCheq_Estandar)THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND CC.TipoChequera = "',TipCheq_Estandar,'"');

			ELSEIF(Par_TipoChequera = TipCheq_Proforma)THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND CC.TipoChequera = "',TipCheq_Proforma,'"');
			END IF;
		END IF;

		-- Filtro por sucursal cuando sea diferente de cero
		IF(IFNULL(Par_SucursalID, Entero_Cero)!=Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND CC.SucursalID = ',Par_SucursalID);
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia,';');

		SET @Sentencia	= CONCAT(Var_Sentencia);

		PREPARE REPORTECHEQUERAS FROM @Sentencia;
		EXECUTE REPORTECHEQUERAS;
		DEALLOCATE PREPARE REPORTECHEQUERAS;

		-- Se cuentan todos los cheques usados (emitidos, aplicados y cancelados por caja)
		-- a partir de la asignacion de la chequera
		INSERT INTO TMPCHEQUESEMI(
					InstitucionID, 		NumCtaInstit,			SucursalID,		CajaID,		TotFoliosUsados,	TipoChequera)
			SELECT
					CA.InstitucionID,	CA.NumCtaInstit,		CA.SucursalID, 	CA.CajaID,	COUNT(CC.NumeroCheque), CA.TipoChequera
				FROM	CHEQUESEMITIDOS CC, CAJASCHEQUERA CA
				WHERE 	DATE(CA.FechaActEstatus) BETWEEN Par_FechaInicio AND Par_FechaFinal
				AND 	DATE(CC.FechaEmision) BETWEEN DATE(CA.FechaActEstatus) AND Par_FechaFinal
				AND 	CC.InstitucionID		= CA.InstitucionID
				AND 	CC.CuentaInstitucion	= CA.NumCtaInstit
                AND 	CC.TipoChequera			= CA.TipoChequera
				AND 	CC.SucursalID			= CA.SucursalID
				AND 	CC.CajaID				= CA.CajaID
				GROUP BY CA.InstitucionID,CA.NumCtaInstit,CA.SucursalID,CA.CajaID,CA.TipoChequera;

		-- Se actualiza el campo Total de Folios Usados
		UPDATE TMPASIGNACHEQUES TA,TMPCHEQUESEMI TC SET
					TA.TotFoliosUsados	= TC.TotFoliosUsados
			WHERE 	TA.InstitucionID	= TC.InstitucionID
			AND 	TA.NumCtaInstit		= TC.NumCtaInstit
            AND 	TA.TipoChequera		= TC.TipoChequera
			AND 	TA.SucursalID		= TC.SucursalID
			AND 	TA.CajaID			= TC.CajaID;

		-- Regresa los valores para mostrar en el reporte
		SELECT
			NombreCortoInst, 		NumCtaInstit,	NombreSucurs,			CajaID, 	DescripcionCaja,
			FolioCheqInicial,		FolioCheqFinal,	UltimoFolioUtilizado,
			((FolioCheqFinal-FolioCheqInicial+Entero_Uno)-IFNULL(TotFoliosUsados,Entero_Cero)) AS FoliosRestantes,
			IFNULL(TotFoliosUsados,Entero_Cero) AS TotFoliosUsados,
			FechaDotacion, 		UsuarioDota, CASE 	WHEN TipoChequera = 'P' THEN 'PROFORMA'
													WHEN TipoChequera = 'E' THEN 'CHEQUERA' END AS TipoChequera
			FROM TMPASIGNACHEQUES;

		DROP TABLE IF EXISTS TMPASIGNACHEQUES;
		DROP TABLE IF EXISTS TMPCHEQUESEMI;

	END IF;

END TerminaStore$$