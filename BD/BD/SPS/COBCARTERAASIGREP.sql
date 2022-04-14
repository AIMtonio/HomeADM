-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBCARTERAASIGREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBCARTERAASIGREP`;DELIMITER $$

CREATE PROCEDURE `COBCARTERAASIGREP`(

	Par_TipoGestor     	CHAR(1),
	Par_SucursalID     	INT(11),
	Par_GestorID      	INT(11),


	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN


	DECLARE	Entero_Cero			INT;
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	DirOfi_Si		CHAR(1);


	DECLARE	Var_Hora			TIME;
	DECLARE	Var_FechaSistema	DATE;
	DECLARE Var_Sentencia		VARCHAR(6000);


	SET	Entero_Cero		:= 0;
    SET Cadena_Vacia	:='';
    SET DirOfi_Si		:='S';


	SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS);


		DROP TABLE IF EXISTS TMPCREDITOSASIGNADOS;
		CREATE TEMPORARY TABLE TMPCREDITOSASIGNADOS(
			GestorID			INT(11),
            NombreGestor		VARCHAR(200),
            TipoAsigCobranzaID	INT(11),
            DescripcionTipAsig	VARCHAR(150),
            FechaAsignacion		DATE,

			ClienteID			BIGINT,
            NombreCompleto		VARCHAR(200),
            SucursalID			INT(11),
            NombreSucursal		VARCHAR(200),
			CreditoID			BIGINT(12),

            ProductoCredID		INT(11),
            DescProductoCred	VARCHAR(100),
            TelefonoFijo		VARCHAR(20),
            TelefonoCelular		VARCHAR(20),
            Domicilio			VARCHAR(500),

            NombreAval			VARCHAR(200),
            DomicilioAval		VARCHAR(500),
            TelefonoAval		VARCHAR(20),
            SolicitudCreditoID	INT(11)
            );

		DROP TABLE IF EXISTS TMPDATOSAVALESSPS;
		CREATE TEMPORARY TABLE TMPDATOSAVALESSPS(
			CreditoID			BIGINT(12),
			SolicitudCreditoID	BIGINT(12),
			AvalID				BIGINT(12),
			ClienteID			BIGINT(12),
			ProspectoID			BIGINT(12),
			NombreCompleto 		VARCHAR(500),
			DireccionCompleta	VARCHAR(500),
			Telefono			VARCHAR(50));
		CREATE INDEX id_indexClienteID ON TMPDATOSAVALESSPS (ClienteID);


	SET Var_Sentencia := CONCAT("
		INSERT INTO TMPCREDITOSASIGNADOS(
				GestorID,			NombreGestor,			TipoAsigCobranzaID, 		DescripcionTipAsig, 	FechaAsignacion,
				ClienteID,			NombreCompleto,			SucursalID,					CreditoID
		)SELECT cca.GestorID,		gc.NombreCompleto,		cca.TipoAsigCobranzaID,		tac.Descripcion,		cca.FechaAsig,
				dca.ClienteID,		dca.NombreCompleto,		dca.SucursalID,				dca.CreditoID
		FROM DETCOBCARTERAASIG dca
		LEFT JOIN COBCARTERAASIG cca
			ON dca.FolioAsigID = cca.FolioAsigID
		LEFT JOIN GESTORESCOBRANZA gc
			ON cca.GestorID = gc.GestorID
		LEFT JOIN TIPOASIGCOBRANZA tac
			ON cca.TipoAsigCobranzaID = tac.TipoAsigCobranzaID
		WHERE dca.CredAsignado = 'S'
			AND gc.TipoGestor = '",Par_TipoGestor,"' ");


		IF(Par_SucursalID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND dca.SucursalID = ",Par_SucursalID);
		END IF;


		IF(Par_GestorID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND cca.GestorID = ",Par_GestorID);
		END IF;

        SET Var_Sentencia := CONCAT(Var_Sentencia, ";");

        SET @Sentencia	= (Var_Sentencia);

		PREPARE COBCARTERAASIGREP FROM @Sentencia;
		EXECUTE COBCARTERAASIGREP;
		DEALLOCATE PREPARE COBCARTERAASIGREP;


		UPDATE TMPCREDITOSASIGNADOS tmp, SUCURSALES suc SET
			tmp.NombreSucursal =  CONCAT(suc.SucursalID,'-',suc.NombreSucurs)
		WHERE tmp.SucursalID = suc.SucursalID;


        UPDATE TMPCREDITOSASIGNADOS tmp
			LEFT JOIN CREDITOS cre
				ON tmp.CreditoID = cre.CreditoID
			LEFT JOIN PRODUCTOSCREDITO pro
				ON cre.ProductoCreditoID = pro.ProducCreditoID SET
			tmp.ProductoCredID 		= cre.ProductoCreditoID,
            tmp.DescProductoCred	= pro.Descripcion,
            tmp.SolicitudCreditoID	= cre.SolicitudCreditoID
		WHERE tmp.CreditoID = cre.CreditoID;


        UPDATE TMPCREDITOSASIGNADOS tmp,CLIENTES cli SET
			tmp.TelefonoFijo 	= cli.Telefono,
            tmp.TelefonoCelular	= cli.TelefonoCelular
		WHERE tmp.ClienteID = cli.ClienteID;


        UPDATE TMPCREDITOSASIGNADOS tmp,DIRECCLIENTE dir SET
            tmp.Domicilio		= dir.DireccionCompleta
		WHERE  tmp.ClienteID = dir.ClienteID
				AND dir.Oficial = DirOfi_Si;


        INSERT INTO TMPDATOSAVALESSPS
			SELECT	tmp.CreditoID,			aps.SolicitudCreditoID,		aps.AvalID,			aps.ClienteID, 	aps.ProspectoID,
					'' AS NombreCompleto,	'' AS DireccionCompleta,	'' AS Telefono
			FROM AVALESPORSOLICI aps
					INNER JOIN TMPCREDITOSASIGNADOS tmp
						ON tmp.SolicitudCreditoID	= aps.SolicitudCreditoID;


		UPDATE TMPDATOSAVALESSPS	T,
				CLIENTES			C	SET
			T.NombreCompleto= C.NombreCompleto,
			T.Telefono		= C.TelefonoCelular
		WHERE T.ClienteID = C.ClienteID;

		UPDATE	TMPDATOSAVALESSPS	T,
				DIRECCLIENTE		D	SET
			T.DireccionCompleta = D.DireccionCompleta
		WHERE T.ClienteID = D.ClienteID
		AND D.Oficial = 'S';


        UPDATE TMPDATOSAVALESSPS	T,
				PROSPECTOS			P	SET
			T.NombreCompleto= P.NombreCompleto,
			T.Telefono		= P.Telefono
		WHERE T.ProspectoID = P.ProspectoID
			AND T.NombreCompleto = Cadena_Vacia;

		UPDATE TMPDATOSAVALESSPS	T,
				PROSPECTOS			P,
				ESTADOSREPUB Est,
				MUNICIPIOSREPUB Mun 	SET
			T.DireccionCompleta	= CONCAT(IFNULL(Calle,Cadena_Vacia), ', ', IFNULL(NumExterior,Cadena_Vacia),', ', IFNULL(Colonia,Cadena_Vacia),' , ', IFNULL(Mun.Nombre,Cadena_Vacia),', ',IFNULL(Est.Nombre,Cadena_Vacia) )
		WHERE T.ProspectoID = P.ProspectoID
			AND P.EstadoID	= Est.EstadoID
			AND P.MunicipioID	= Mun.MunicipioID
			AND Mun.EstadoID	= Est.EstadoID
			AND T.DireccionCompleta = Cadena_Vacia;


        UPDATE TMPDATOSAVALESSPS	T,
				AVALES				A	SET
			T.NombreCompleto= A.NombreCompleto,
			T.Telefono		= A.TelefonoCel
		WHERE T.AvalID = A.AvalID
			AND T.NombreCompleto = Cadena_Vacia;

		UPDATE TMPDATOSAVALESSPS	T,
				AVALES				A	SET
			T.DireccionCompleta = A.DireccionCompleta
		WHERE T.AvalID = A.AvalID
			AND T.DireccionCompleta = Cadena_Vacia;


		UPDATE TMPCREDITOSASIGNADOS tmp, TMPDATOSAVALESSPS av SET
			tmp.NombreAval 		= av.NombreCompleto,
            tmp.DomicilioAval	= av.DireccionCompleta,
            tmp.TelefonoAval	= av.Telefono
		WHERE tmp.CreditoID = av.CreditoID;



    SELECT 	GestorID,			NombreGestor,			DescripcionTipAsig, 	FechaAsignacion,            ClienteID,
            NombreCompleto,		NombreSucursal,			CreditoID,				DescProductoCred,           TelefonoFijo,
            TelefonoCelular,	Domicilio,				NombreAval,				DomicilioAval,	            TelefonoAval
	FROM TMPCREDITOSASIGNADOS;

	DROP TABLE IF EXISTS TMPCREDITOSASIGNADOS;

END TerminaStore$$