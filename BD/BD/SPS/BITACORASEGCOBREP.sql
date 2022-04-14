-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORASEGCOBREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORASEGCOBREP`;DELIMITER $$

CREATE PROCEDURE `BITACORASEGCOBREP`(

	Par_FechaIniReg		DATE,
	Par_CreditoID		BIGINT(12),
    Par_FechaFinReg		DATE,
    Par_UsuarioReg		INT(11),
    Par_AccionID		INT(11),

    Par_FechaIniProm	DATE,
    Par_RespuestaID		INT(11),
    Par_FechaFinProm	DATE,
	Par_ClienteID		BIGINT(12),
	Par_LimiteRenglones	INT(11),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN



	DECLARE	FechaSist			DATE;


	DECLARE Var_Sentencia		VARCHAR(6000);

    DECLARE Entero_Cero			INT(11);
    DECLARE Cadena_Vacia		CHAR(1);
    DECLARE Fecha_Vacia			DATE;


    SET Entero_Cero				:= 0;
    SET Cadena_Vacia			:= '';
    SET Fecha_Vacia				:= '1900-01-01';

	SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);

    DROP TABLE IF EXISTS TMPREPORTEBITACORA;
		CREATE TEMPORARY TABLE TMPREPORTEBITACORA(
			FechaRegistro		DATE,
			UsuarioID			INT(11),
            NombreSucursal		VARCHAR(100),
			CreditoID			BIGINT(12),
			ClienteID			INT(11),

            DescAccion			VARCHAR(200),
            DescRespuesta		VARCHAR(200),
			Comentarios			VARCHAR(300),
            EtapaCobranza		VARCHAR(20),
			FechaEntregaDoc		VARCHAR(10),

			FechaPromPago		DATE,
            MontoPromPago		DECIMAL(16,2),
			ComentariosProm		VARCHAR(300),
            SucursalID			INT(11),
            NumPromesa			INT(11),

            NombreCliente		VARCHAR(200),
            ClaveUsuario		VARCHAR(45)
		);

    SET Var_Sentencia := CONCAT("INSERT INTO TMPREPORTEBITACORA(
					FechaRegistro,		UsuarioID,		CreditoID,			ClienteID, 			DescAccion,
					DescRespuesta,	Comentarios,		EtapaCobranza,		FechaEntregaDoc,
					FechaPromPago,		MontoPromPago,	ComentariosProm,	SucursalID,		NumPromesa
			)
            SELECT 	bsc.Fecha, 			bsc.UsuarioID, 	bsc.CreditoID, 		bsc.ClienteID, 		tac.Descripcion,
					trc.Descripcion,	bsc.Comentario, bsc.EtiquetaEtapa, 	bsc.FechaEntregaDoc,	psc.FechaPromPago,
					psc.MontoPromPago,	psc.ComentarioProm,	bsc.SucursalID,	psc.NumPromesa
			FROM PROMESASEGCOB psc
				LEFT JOIN BITACORASEGCOB bsc
					ON psc.BitacoraID = bsc.BitacoraID
				INNER JOIN TIPOACCIONCOB tac
					ON bsc.AccionID = tac.AccionID
				INNER JOIN TIPORESPUESTACOB trc
					ON bsc.RespuestaID = trc.RespuestaID AND bsc.AccionID = trc.AccionID
				WHERE psc.BitacoraID > 0 ");



		IF(Par_FechaIniReg <> Fecha_Vacia)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND 	bsc.Fecha >= '",Par_FechaIniReg,"'");
		END IF;

		IF(Par_FechaFinReg <> Fecha_Vacia)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND 	bsc.Fecha <= '",Par_FechaFinReg,"'");
		END IF;


		IF(Par_CreditoID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND bsc.CreditoID = ",Par_CreditoID);
		END IF;


		IF(Par_UsuarioReg > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND bsc.UsuarioID = ",Par_UsuarioReg);
		END IF;


		IF(Par_AccionID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND bsc.AccionID = ",Par_AccionID);
		END IF;


		IF(Par_RespuestaID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND bsc.RespuestaID = ",Par_RespuestaID);
		END IF;



		IF(Par_FechaIniProm <> Fecha_Vacia)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND psc.FechaPromPago >= '",Par_FechaIniProm,"'");
		END IF;

		IF(Par_FechaFinProm <> Fecha_Vacia)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND psc.FechaPromPago <= '",Par_FechaFinProm,"'");
		END IF;


		IF(Par_ClienteID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND bsc.ClienteID = ",Par_ClienteID);
		END IF;


        SET Var_Sentencia := CONCAT(Var_Sentencia, "  ORDER BY bsc.ClienteID, bsc.Fecha, psc.NumPromesa	");


    	IF(Par_LimiteRenglones > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " LIMIT ",Par_LimiteRenglones);
		END IF;

        SET Var_Sentencia := CONCAT(Var_Sentencia, " ;");

		SET @Sentencia	= (Var_Sentencia);

		PREPARE BITACORASEGCOBREP FROM @Sentencia;
		EXECUTE BITACORASEGCOBREP;
		DEALLOCATE PREPARE BITACORASEGCOBREP;


		UPDATE TMPREPORTEBITACORA tmp, SUCURSALES suc SET
			tmp.NombreSucursal =  CONCAT(suc.SucursalID,'-',suc.NombreSucurs)
		WHERE tmp.SucursalID = suc.SucursalID;


		UPDATE TMPREPORTEBITACORA tmp, CLIENTES	cli SET
			tmp.NombreCliente =  cli.NombreCompleto
		WHERE tmp.ClienteID = cli.ClienteID;


		UPDATE TMPREPORTEBITACORA tmp, USUARIOS	usu SET
			tmp.ClaveUsuario =  usu.Clave
		WHERE tmp.UsuarioID = usu.UsuarioID;


    SELECT	FechaRegistro,		UsuarioID,		NombreSucursal,		CreditoID,		ClienteID,
			DescAccion,			DescRespuesta,	Comentarios,		EtapaCobranza,	CASE WHEN FechaEntregaDoc = Fecha_Vacia THEN Cadena_Vacia ELSE FechaEntregaDoc END AS FechaEntregaDoc  ,
			FechaPromPago,		MontoPromPago,	ComentariosProm,	NombreCliente,	UPPER(ClaveUsuario) AS ClaveUsuario
	FROM TMPREPORTEBITACORA;

END TerminaStore$$