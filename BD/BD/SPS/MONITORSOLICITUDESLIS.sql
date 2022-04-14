-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONITORSOLICITUDESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONITORSOLICITUDESLIS`;
DELIMITER $$


CREATE PROCEDURE `MONITORSOLICITUDESLIS`(
	/* SP QUE LISTA LOS ESTATUS Y DETALLE DE LAS SOLICITUDES DE CREDITO */
    Par_NumLis 			TINYINT UNSIGNED,
	Par_FechaInicial 	DATE,
	Par_Sucursal 		INT(11),
	Par_Promotor 		INT(11),

	Par_Estatus 		CHAR(2),
	Par_ProductoCredito	INT(11),
    Par_Usuario			INT(11),

    -- Parametros de Auditoria --
	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion  BIGINT(20)
	)

TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Comentario	VARCHAR(500);
	DECLARE Var_Fecha		DATETIME;
    DECLARE Var_AccesoMonitor	CHAR(1);

	-- Declaracion de Constantes
	DECLARE Fecha_Vacia 				DATE;
	DECLARE Entero_Cero 				INT(11);
	DECLARE Cadena_Vacia				CHAR(2);
	DECLARE Var_Sentencia 				VARCHAR(6000);
	DECLARE Var_ClienteInst				INT(11);
	DECLARE Lis_EstSolicitudes			INT(11);
	DECLARE Lis_DetalleSolicitudes		INT(11);
	DECLARE Lis_CanalIngreso			INT(11);
	DECLARE Lis_DetalleSolicitudesCC	INT(11);
	DECLARE Est_CredVig					CHAR(1);
	DECLARE Est_CredPag					CHAR(1);
	DECLARE Est_CredCanc				CHAR(1);
	DECLARE Est_CredVenc				CHAR(1);
	DECLARE Est_CredCastig				CHAR(1);
	DECLARE Est_CredDes					CHAR(1);
	DECLARE Est_CredDesem				CHAR(2);
    DECLARE Est_CredAut					CHAR(1);
    DECLARE Est_CredAutorizado			CHAR(2);
    DECLARE Est_CredInac				CHAR(1);
    DECLARE Est_CreditoInactivo			CHAR(2);
    DECLARE Est_SolInac					CHAR(1);
    DECLARE Est_SolInactiva				CHAR(2);
    DECLARE Est_SolAut					CHAR(1);
    DECLARE Est_SolAutorizada			CHAR(2);
    DECLARE Est_SolLib					CHAR(1);
    DECLARE Est_SolLiberada				CHAR(2);
    DECLARE Est_SolDesem				CHAR(1);
    DECLARE Est_SolDesembolsada			CHAR(2);
    DECLARE Est_SolRech					CHAR(1);
    DECLARE Est_SolRechazada			CHAR(2);
    DECLARE Est_SolCanc					CHAR(1);
    DECLARE Est_SolCancelada			CHAR(2);
    DECLARE Est_SolActualizada			CHAR(2);
    DECLARE Est_CredCond				CHAR(2);
    DECLARE Condiciona_SI				CHAR(1);
    DECLARE TxtCreditosCond				VARCHAR(30);
    DECLARE TxtCreditosAut				VARCHAR(30);
    DECLARE TxtCreditosInac				VARCHAR(30);
    DECLARE TxtCreditosDesem			VARCHAR(30);
    DECLARE TxtSolAutorizadas			VARCHAR(30);
    DECLARE TxtSolCanceladas			VARCHAR(30);
    DECLARE TxtSolDesembolsadas			VARCHAR(30);
    DECLARE TxtSolInactivas				VARCHAR(30);
    DECLARE TxtSolLiberadas				VARCHAR(30);
    DECLARE TxtSolRechazadas			VARCHAR(30);
    DECLARE TxtSolActualizadas			VARCHAR(30);
    DECLARE NumUno						INT(11);
    DECLARE NumDos						INT(11);
    DECLARE NumTres						INT(11);
    DECLARE NumCuatro					INT(11);
    DECLARE NumCinco					INT(11);
    DECLARE NumSeis						INT(11);
    DECLARE NumSiete					INT(11);
    DECLARE NumOcho						INT(11);
	DECLARE NumNueve					INT(11);
    DECLARE NumDiez						INT(11);
    DECLARE Sucursal					CHAR(1);
    DECLARE BancaMovil					CHAR(1);
    DECLARE BancaLinea					CHAR(1);
    DECLARE SucursalTxt					VARCHAR(20);
    DECLARE BancaLineaTxt				VARCHAR(20);
    DECLARE BancaMovilTxt				VARCHAR(20);
    DECLARE Var_NO						CHAR(1);
	DECLARE SinAnalista                 VARCHAR(15);
	DECLARE AnalistaVirtual             VARCHAR(30);
	DECLARE NA                          VARCHAR(5);
	DECLARE Var_SI                      CHAR(1);
	 -- Asignacion de Constantes
	SET Fecha_Vacia 					:='1900-01-01';
	SET Entero_Cero 					:= 0;
	SET Lis_EstSolicitudes 				:= 1;		-- Num. Lista Estatus Solicitudes
	SET Lis_DetalleSolicitudes 			:= 2;		-- Num. Lista Detalle de las Solicitudes
	SET Lis_CanalIngreso				:= 3;		-- Num. Lista Canal de Ingreso
	SET Lis_DetalleSolicitudesCC 		:= 4;		-- Num. Lista Detalle de Creditos Condicionados
	SET Cadena_Vacia					:= '';
    SET Condiciona_SI					:= 'S';

	SET Est_CredVig						:= 'V';		-- Estatus Credito Vigente
	SET Est_CredPag						:= 'P';		-- Estatus Credito Pagado
	SET Est_CredCanc					:= 'C';		-- Estatus Credito Cancelado
	SET Est_CredVenc					:= 'B';		-- Estatus Credito Vencido
	SET Est_CredCastig					:= 'K';		-- Estatus Credito Castigado
	SET Est_CredDes						:= 'D';		-- Estatus Credito Desembolsado
	SET Est_CredDesem					:= 'CD';	-- Creditos Desembolsados
    SET Est_CredAut						:= 'A';		-- Estatus Credito Autorizado
    SET Est_CredAutorizado				:= 'CA';	-- Creditos Autorizados
    SET Est_CredInac					:= 'I';		-- Estatus Credito Inactivo
    SET Est_CreditoInactivo				:= 'CI';	-- Creditos Inactivos
	SET Est_SolInac						:= 'I';		-- Estatus Solicitud Inactiva
    SET Est_SolInactiva					:= 'SI';	-- Solicitudes Inactivas
    SET Est_SolAut						:= 'A';		-- Estatus Solicitud Autorizada
    SET Est_SolAutorizada				:= 'SA';	-- Solicitudes Autorizadas
    SET Est_SolLib						:= 'L';		-- Estatus Solicitud Liberada
    SET Est_SolLiberada					:= 'SL';	-- Solicitudes Liberadas
    SET Est_SolDesem					:= 'D';		-- Estatus Solicitud Desembolsada
    SET Est_SolDesembolsada				:= 'SD';	-- Solicitudes Desembolsadas
    SET Est_SolRech						:= 'R';		-- Estatus Solicitud Rechazada
    SET Est_SolRechazada				:= 'SR';	-- Solicitudes Rechazadas
    SET Est_SolCanc						:= 'C';		-- Estatus Solicitud Cancelada
    SET Est_SolCancelada				:= 'SC';	-- Solicitudes Canceladas
    SET Est_SolActualizada				:= 'SM';	-- Solicitudes Regresadas al Ejecutivo
    SET	Est_CredCond					:= 'CC';		-- Creditos Condicionados
	SET TxtCreditosCond					:= 'Creditos Condicionados';
    SET TxtCreditosAut					:= 'Creditos Autorizados';
    SET TxtCreditosInac					:= 'Creditos Registrados';
    SET TxtCreditosDesem				:= 'Creditos Desembolsados';
    SET TxtSolAutorizadas				:= 'Solicitudes Autorizadas';
    SET TxtSolCanceladas				:= 'Solicitudes Canceladas';
    SET TxtSolDesembolsadas				:= 'Solicitudes Desembolsadas';
    SET TxtSolInactivas					:= 'Solicitudes Registradas';
    SET TxtSolLiberadas					:= 'Solicitudes Liberadas';
    SET TxtSolRechazadas				:= 'Solicitudes Rechazadas';
    SET TxtSolActualizadas				:= 'Solicitudes en Actualizacion';
    SET NumUno							:= 1;
    SET NumDos							:= 2;
    SET NumTres							:= 3;
    SET NumCuatro						:= 4;
    SET NumCinco						:= 5;
    SET NumSeis							:= 6;
    SET NumSiete						:= 7;
    SET NumOcho							:= 8;
	SET NumNueve						:= 9;
    SET NumDiez							:= 10;
    SET Sucursal						:= 'S';
    SET BancaMovil						:= 'M';
    SET BancaLinea						:= 'L';
    SET SucursalTxt						:= 'Sucursal';
    SET BancaLineaTxt					:= 'Banca Electronica';
    SET BancaMovilTxt					:= 'Banca Movil';
    SET Var_NO							:= 'N';
	SET SinAnalista                     := 'SIN ANALISTA';
	SET AnalistaVirtual                 := 'ANALISTA VIRTUAL';
	SET NA                              := 'N/A';
    SET Var_SI                          := 'S';

	IF(Par_NumLis = Lis_EstSolicitudes) THEN
		-- Se eliminan los registros del Usuario que accede
		DELETE FROM MONITORCONSULTAGLOBAL
		WHERE UsuarioConsulta = Par_Usuario;

		DELETE FROM ESTATUSSOLUSUARIO
		WHERE UsuarioConsulta = Par_Usuario;

		SET Var_AccesoMonitor := (SELECT AccesoMonitor FROM  USUARIOS
									WHERE UsuarioID = Par_Usuario);



		-- Se llena la Tabla MONITORCONSULTAGLOBAL de acuerdo a los filtros recibidos (SOLICITUDES DE CREDITO)
		SET Var_Sentencia := '
			INSERT INTO MONITORCONSULTAGLOBAL (
				Transaccion,		 SolicitudCreditoID,    ClienteID,	     	ProspectoID,            PromotorID,
				UsuarioID,   		 SucursalID,     	    Estatus,            FechaRegistro,          CanalIngreso,
                ProductoCreditoID,	 UsuarioConsulta,       Condicionada)';
        SET Var_Sentencia := CONCAT(Var_Sentencia, '
			(SELECT CONVERT("',Aud_NumTransaccion,'",UNSIGNED INT),	S.SolicitudCreditoID,	S.ClienteID,
							S.ProspectoID,		S.PromotorID,		S.UsuarioAltaSol,		S.SucursalID,
                                                                                                        S.Estatus,
							S.FechaRegistro,
							S.CanalIngreso,    	S.ProductoCreditoID,',Par_Usuario,',S.Condicionada
							FROM SOLICITUDCREDITO S
							INNER JOIN PRODUCTOSCREDITO P ON P.ProducCreditoID=S.ProductoCreditoID
                            INNER JOIN SOLICITUDESASIGNADAS SOL ON SOL.SolicitudCreditoID=S.SolicitudCreditoID
                            WHERE  S.Estatus NOT IN ("R","C","D")');
		SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	P.RequiereAnalisiCre= "', Var_SI ,'"');

		-- Filtro por Sucursal
		IF  (IFNULL(Par_Sucursal, Entero_Cero) != Entero_Cero ) THEN
				SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	S.SucursalID = ', Par_Sucursal );
		END IF;

        -- Filtro por Promotor
		IF  (IFNULL(Par_Promotor, Entero_Cero) != Entero_Cero ) THEN
			SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	S.PromotorID = ', Par_Promotor );
		END IF;

        -- Filtro por Producto de Credito
		IF  (IFNULL(Par_ProductoCredito, Entero_Cero) != Entero_Cero ) THEN
			SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	S.ProductoCreditoID = ', Par_ProductoCredito );
		END IF;


		SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	SOL.UsuarioID  = ', Par_Usuario );

        IF  (IFNULL(Par_Estatus, Cadena_Vacia) = Est_SolRechazada ) THEN
			SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	S.FechaRechazo = "', Par_FechaInicial,'"');
		END IF;


		SET Var_Sentencia := CONCAT(Var_Sentencia, ') UNION
			(SELECT CONVERT("',Aud_NumTransaccion,'",UNSIGNED INT),	S.SolicitudCreditoID,	S.ClienteID,
							S.ProspectoID,		S.PromotorID,		S.UsuarioAltaSol,		S.SucursalID,
                                                                                                        S.Estatus,
							S.FechaRegistro,
							S.CanalIngreso,    	S.ProductoCreditoID,',Par_Usuario,',S.Condicionada
							FROM SOLICITUDCREDITO S
							INNER JOIN PRODUCTOSCREDITO P ON P.ProducCreditoID=S.ProductoCreditoID
                            WHERE  S.Estatus NOT IN ("R","C","D")');

		-- Filtro por Sucursal
		IF  (IFNULL(Par_Sucursal, Entero_Cero) != Entero_Cero ) THEN
				SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	S.SucursalID = ', Par_Sucursal );
		END IF;

        -- Filtro por Promotor
		IF  (IFNULL(Par_Promotor, Entero_Cero) != Entero_Cero ) THEN
			SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	S.PromotorID = ', Par_Promotor );
		END IF;

        -- Filtro por Producto de Credito
		IF  (IFNULL(Par_ProductoCredito, Entero_Cero) != Entero_Cero ) THEN
			SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	S.ProductoCreditoID = ', Par_ProductoCredito );
		END IF;

        IF  (IFNULL(Var_AccesoMonitor, Cadena_Vacia) = Var_NO ) THEN
			SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	S.UsuarioAltaSol = ', Par_Usuario );
		END IF;

        IF  (IFNULL(Par_Estatus, Cadena_Vacia) = Est_SolRechazada ) THEN
			SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	S.FechaRechazo = "', Par_FechaInicial,'"');
		END IF;

		SET Var_Sentencia	:= CONCAT(Var_Sentencia,');');

		SET @Sentencia	= (Var_Sentencia);

		PREPARE STMONITORCONSULTAGLOBAL FROM @Sentencia;
		EXECUTE STMONITORCONSULTAGLOBAL;
		DEALLOCATE PREPARE STMONITORCONSULTAGLOBAL;

        -- Se llena la Tabla MONITORCONSULTAGLOBAL de acuerdo a los filtros recibidos (CREDITOS SIN SOLICITUD)
		SET Var_Sentencia := '
			INSERT INTO MONITORCONSULTAGLOBAL (
				Transaccion,		SolicitudCreditoID,		CreditoID, ClienteID,		UsuarioID,   		SucursalID,
                Estatus, FechaRegistro,	 	CanalIngreso,		ProductoCreditoID,	UsuarioConsulta,
                Condicionada)';

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, '
			SELECT CONVERT("',Aud_NumTransaccion,'",UNSIGNED INT),	0,	S.CreditoID,C.ClienteID, S.UsuarioID,     C.SucursalID,
                           C.Estatus,	S.FechaRegistro,			S.CanalIngreso,    	C.ProductoCreditoID,',Par_Usuario,',
                           S.Condicionada
							FROM SOLICITUDESCERO S
                            INNER JOIN CREDITOS C
                            ON S.CreditoID = C.CreditoID
                            WHERE C.Estatus NOT IN("P","B","K","D","V")');

		-- Filtro por Sucursal
		IF  (IFNULL(Par_Sucursal, Entero_Cero) != Entero_Cero ) THEN
				SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	C.SucursalID = ', Par_Sucursal );
		END IF;

        -- Filtro por Producto de Credito
		IF  (IFNULL(Par_ProductoCredito, Entero_Cero) != Entero_Cero ) THEN
			SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	C.ProductoCreditoID = ', Par_ProductoCredito );
		END IF;

        IF  (IFNULL(Var_AccesoMonitor, Cadena_Vacia) = 'N' ) THEN
			SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	S.UsuarioID = ', Par_Usuario );
		END IF;

		SET Var_Sentencia	:= CONCAT(Var_Sentencia,';');


		SET @Sentencia	= (Var_Sentencia);

		PREPARE STMONITORCONSULTACRED FROM @Sentencia;
		EXECUTE STMONITORCONSULTACRED;
		DEALLOCATE PREPARE STMONITORCONSULTACRED;

        SET Var_Sentencia := '
			INSERT INTO MONITORCONSULTAGLOBAL (
				Transaccion,		SolicitudCreditoID,		CreditoID,          ClienteID,		    UsuarioID,
				SucursalID,          Estatus,               FechaRegistro,	    CanalIngreso,       ProductoCreditoID,
				UsuarioConsulta,     Condicionada)';

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, '
			SELECT CONVERT("',Aud_NumTransaccion,'",UNSIGNED INT),	S.SolicitudCreditoID,	S.CreditoID,S.ClienteID, S.UsuarioAltaSol,     C.SucursalID,
                           S.Estatus,	S.FechaRegistro,			S.CanalIngreso,    	C.ProductoCreditoID,',Par_Usuario,',
                           S.Condicionada
							FROM SOLICITUDCREDITO S
                            LEFT JOIN CREDITOS C
                            ON S.SolicitudCreditoID = C.SolicitudCreditoID
                            WHERE  S.Estatus IN ("R","C","D")
                            AND CASE WHEN S.Estatus = "R" THEN DATE(S.FechaRechazo) = "',Par_FechaInicial,'"
									WHEN S.Estatus = "D" THEN C.FechaMinistrado = "',Par_FechaInicial,'"
                                    END');

		IF  (IFNULL(Par_Sucursal, Entero_Cero) != Entero_Cero ) THEN
				SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	C.SucursalID = ', Par_Sucursal );
		END IF;


		IF  (IFNULL(Par_ProductoCredito, Entero_Cero) != Entero_Cero ) THEN
			SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	C.ProductoCreditoID = ', Par_ProductoCredito );
		END IF;

        IF  (IFNULL(Var_AccesoMonitor, Cadena_Vacia) = 'N' ) THEN
			SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	S.UsuarioAltaSol = ', Par_Usuario );
		END IF;

		SET Var_Sentencia	:= CONCAT(Var_Sentencia,';');

		SET @Sentencia	= (Var_Sentencia);

		PREPARE STMONITORCONSULTA FROM @Sentencia;
		EXECUTE STMONITORCONSULTA;
		DEALLOCATE PREPARE STMONITORCONSULTA;


        UPDATE MONITORCONSULTAGLOBAL
        SET Estatus = CASE WHEN Estatus = Est_CredInac AND Condicionada = "N" THEN Est_CreditoInactivo 	-- Credito Inactiva
								WHEN Estatus = Est_CredInac AND Condicionada = "S" THEN Est_CredCond 	-- Credito Condicionada
								WHEN Estatus = Est_CredAut THEN Est_CredAutorizado
								WHEN Estatus = Est_CredPag THEN Est_CredDesem
								WHEN Estatus = Est_CredVenc THEN Est_CredDesem
								WHEN Estatus = Est_CredCastig THEN Est_CredDesem
								WHEN Estatus = Est_CredDes THEN Est_CredDesem
								WHEN Estatus = Est_CredVig THEN Est_CredDesem
							END
				WHERE Transaccion = Aud_NumTransaccion
                AND SolicitudCreditoID = Entero_Cero;

        UPDATE MONITORCONSULTAGLOBAL M
        LEFT OUTER JOIN CREDITOS C
        ON M.SolicitudCreditoID = C.SolicitudCreditoID
        SET M.Estatus = CASE WHEN M.Estatus = Est_SolInac THEN Est_SolInactiva -- Solicitud Inactiva
								WHEN M.Estatus = Est_SolLib THEN Est_SolLiberada -- Solicitud Liberada
								WHEN M.Estatus = Est_SolRech THEN Est_SolRechazada -- Solicitud Rechazada
								WHEN M.Estatus = Est_SolAut AND IFNULL(C.Estatus,Cadena_Vacia)= Cadena_Vacia THEN Est_SolAutorizada -- Solicitud Autorizada
								WHEN M.Estatus = Est_SolCanc THEN Est_SolCancelada								-- Solicitud Cancelada
								WHEN M.Estatus = Est_SolDesem AND IFNULL(C.Estatus, Cadena_Vacia) = Cadena_Vacia THEN Est_SolDesembolsada -- Solicitud Desembolsada
								WHEN C.Estatus = Est_CredInac AND M.Condicionada = "N" THEN Est_CreditoInactivo 	-- Solicitud Inactiva
								WHEN C.Estatus = Est_CredInac AND M.Condicionada = "S" THEN Est_CredCond 	-- Credito Condicionada
								WHEN C.Estatus = Est_CredAut THEN Est_CredAutorizado
								WHEN C.Estatus = Est_CredPag THEN Est_CredDesem
								WHEN C.Estatus = Est_CredVenc THEN Est_CredDesem
								WHEN C.Estatus = Est_CredCastig THEN Est_CredDesem
								WHEN C.Estatus = Est_CredDes THEN Est_CredDesem
								WHEN C.Estatus = Est_CredVig THEN Est_CredDesem
							END
				WHERE M.Transaccion = Aud_NumTransaccion
                AND M.SolicitudCreditoID !=0;

        -- Se actualiza el campo Orden de acuerdo al Estatus de la Solicitud
		UPDATE MONITORCONSULTAGLOBAL T
		SET  T.Orden	=	CASE T.Estatus
								WHEN Est_SolInactiva 		THEN NumUno
								WHEN Est_SolLiberada 		THEN NumDos
								WHEN Est_SolActualizada 	THEN NumTres
								WHEN Est_SolAutorizada 		THEN NumCuatro
								WHEN Est_SolRechazada 		THEN NumCinco
								WHEN Est_SolCancelada 		THEN NumSeis
								WHEN Est_CreditoInactivo	THEN NumSiete
								WHEN Est_CredCond 			THEN NumOcho
								WHEN Est_CredAutorizado 	THEN NumNueve
								WHEN Est_CredDesem 			THEN NumDiez

							END
			WHERE T.Transaccion = Aud_NumTransaccion;

        -- Se actualiza el campo Estatus cuando la Solicitud fue Regresada por el Ejecutivo
        UPDATE MONITORCONSULTAGLOBAL T,
				COMENTARIOSSOL C
		SET T.Estatus	= C.Estatus
		WHERE T.Transaccion = Aud_NumTransaccion
			AND T.SolicitudCreditoID = C.SolicitudCreditoID
			AND T.Estatus = Est_SolInactiva
			AND C.Estatus = Est_SolActualizada;


		/* Tabla temporal que almacena los diferentes estatus de la Solicitud de Credito
		y el Total de cada uno de ellos pero de acuerdo al Usuario Logueado*/

		 SET Var_Sentencia :=  '
			INSERT INTO ESTATUSSOLUSUARIO (
					Transaccion,
					TipoEstatus,
					TotalEstatus,
					Orden,
                    UsuarioConsulta)
			';

		SET Var_Sentencia := CONCAT(Var_Sentencia,'
			SELECT CONVERT("',Aud_NumTransaccion,'",UNSIGNED INT), Tmp.Estatus,COUNT(Tmp.Estatus), Tmp.Orden, Tmp.UsuarioConsulta
			FROM MONITORCONSULTAGLOBAL Tmp');

	    SET Var_Sentencia	:= CONCAT(Var_Sentencia,' WHERE Tmp.Transaccion =', Aud_NumTransaccion);

        IF  (IFNULL(Par_Estatus,Cadena_Vacia) != Cadena_Vacia ) THEN
			SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	Tmp.Estatus = "', Par_Estatus,'"');
		END IF;

		SET Var_Sentencia	:= CONCAT(Var_Sentencia,' GROUP BY Tmp.Estatus, Tmp.Orden, Tmp.UsuarioConsulta');
		SET Var_Sentencia	:= CONCAT(Var_Sentencia,';');

		SET @Sentencia	= (Var_Sentencia);

		PREPARE STMONITORSOLICITUDESCONU FROM @Sentencia;
		EXECUTE STMONITORSOLICITUDESCONU;
		DEALLOCATE PREPARE STMONITORSOLICITUDESCONU;

        /* Consulta que muestra el Estatus, la Descripcion del Estatus
			el Total de cada estatus y el Total de Estatus del Usuario Logueado*/
        SELECT TipoEstatus AS EstatusValor,CASE TipoEstatus
			WHEN Est_CredCond 			THEN TxtCreditosCond
			WHEN Est_CredAutorizado 	THEN TxtCreditosAut
			WHEN Est_CreditoInactivo 	THEN TxtCreditosInac
			WHEN Est_CredDesem 			THEN TxtCreditosDesem
			WHEN Est_SolAutorizada 		THEN TxtSolAutorizadas
			WHEN Est_SolCancelada 		THEN TxtSolCanceladas
			WHEN Est_SolDesembolsada	THEN TxtSolDesembolsadas
			WHEN Est_SolInactiva 		THEN TxtSolInactivas
			WHEN Est_SolLiberada 		THEN TxtSolLiberadas
			WHEN Est_SolRechazada 		THEN TxtSolRechazadas
            WHEN Est_SolActualizada		THEN TxtSolActualizadas

		END AS TipoEstatus,	IFNULL(TotalEstatus,Entero_Cero) AS TotalEstatusU
			FROM ESTATUSSOLUSUARIO
            WHERE Transaccion = Aud_NumTransaccion
			ORDER BY	Orden ASC;


	END IF;

    IF(Par_NumLis = Lis_DetalleSolicitudes) THEN

	-- Tabla auxiliar para el reporte de las descripciones de solicitudes rechazadas
	DROP TABLE IF EXISTS TMPCATRECHAZOS;
	CREATE TEMPORARY TABLE TMPCATRECHAZOS(
	SolicitudCreditoID		BIGINT(20),
	MotivoRechaDevolucion	VARCHAR(2000));


	-- Se realiza el insert a la tabla temporal de las descripciones de los estatus de devoluciones de solicitudes
	INSERT INTO TMPCATRECHAZOS(SolicitudCreditoID,MotivoRechaDevolucion)
		SELECT MAX(T.SolicitudCreditoID),GROUP_CONCAT( Cat.Descripcion) FROM
		MONITORCONSULTAGLOBAL T  INNER JOIN
		CATALOGOMOTRECHAZO Cat
		WHERE  FIND_IN_SET(Cat.MotivoRechazoID,T.MotivoRechazoID) > Entero_Cero
		AND  Cat.TipoMotivo = 'D'
		GROUP BY T.SolicitudCreditoID ;

	-- ACTUALIZACION DE CAMPOS

		-- Cliente
		UPDATE  MONITORCONSULTAGLOBAL T,
				CLIENTES C
		SET T.NombreCompleto = C.NombreCompleto
		WHERE T.Transaccion = Aud_NumTransaccion
		AND T.ClienteID=C.ClienteID;

		-- Prospecto
		UPDATE MONITORCONSULTAGLOBAL T,
				PROSPECTOS P
		SET T.NombreProspecto = P.NombreCompleto
		WHERE T.Transaccion = Aud_NumTransaccion
        AND T.ProspectoID = P.ProspectoID;

		-- Promotores
		UPDATE MONITORCONSULTAGLOBAL T,
				PROMOTORES P
		SET T.NombrePromotor = P.NombrePromotor
		WHERE T.Transaccion = Aud_NumTransaccion
        AND T.PromotorID = P.PromotorID;

		-- Usuarios
		UPDATE MONITORCONSULTAGLOBAL T,
				USUARIOS U
		SET T.NombreUsuario = U.NombreCompleto
		WHERE T.Transaccion = Aud_NumTransaccion
        AND T.UsuarioID = U.UsuarioID;
        -- Estatus a no asignadas
      	UPDATE MONITORCONSULTAGLOBAL T
		SET T.EstatusSolicitud=Var_NO
		WHERE T.Transaccion = Aud_NumTransaccion ;

		-- Tipo Asignacion
		UPDATE MONITORCONSULTAGLOBAL T
		SET T.TipoAsignacionID = Entero_Cero
		WHERE T.Transaccion = Aud_NumTransaccion;

		UPDATE MONITORCONSULTAGLOBAL T,
		       SOLICITUDESASIGNADAS S
		SET T.TipoAsignacionID = S.TipoAsignacionID
		WHERE T.Transaccion = Aud_NumTransaccion
		AND   T.SolicitudCreditoID=S.SolicitudCreditoID;

		-- Usuarios Analistas
		UPDATE MONITORCONSULTAGLOBAL T,
			USUARIOS U
		SET T.ClaveUsuario = SinAnalista
		WHERE T.Transaccion = Aud_NumTransaccion
        AND T.UsuarioID = U.UsuarioID;

		UPDATE MONITORCONSULTAGLOBAL T,
			   USUARIOS U,
			   SOLICITUDESASIGNADAS S
		SET T.UsuarioIDAnalista=S.UsuarioID,
			T.EstatusSolicitud=S.Estatus
		WHERE T.Transaccion = Aud_NumTransaccion
		AND S.SolicitudCreditoID=T.SolicitudCreditoID
		AND T.UsuarioID = U.UsuarioID ;

		UPDATE  MONITORCONSULTAGLOBAL T,
		        USUARIOS U
		SET T.ClaveUsuario=AnalistaVirtual
		WHERE T.Transaccion = Aud_NumTransaccion
		AND T.UsuarioIDAnalista = Entero_Cero ;

		UPDATE  MONITORCONSULTAGLOBAL T,
		        USUARIOS U
		SET T.ClaveUsuario=U.Clave
		WHERE T.Transaccion = Aud_NumTransaccion
		AND T.UsuarioIDAnalista = U.UsuarioID ;

	   -- Motivo rechazo o devolucion
	    UPDATE MONITORCONSULTAGLOBAL T
		SET T.DescripcionRegreso = NA
		WHERE T.Transaccion = Aud_NumTransaccion;

		UPDATE MONITORCONSULTAGLOBAL T,
		       SOLICITUDCREDITO  S
		SET T.MotivoRechazoID = S.MotivoRechazoID
		WHERE T.Transaccion = Aud_NumTransaccion
		AND  T.SolicitudCreditoID=S.SolicitudCreditoID;

		UPDATE MONITORCONSULTAGLOBAL T
	    INNER JOIN TMPCATRECHAZOS Tmpc
		ON T.SolicitudCreditoID =Tmpc.SolicitudCreditoID
		SET
		   T.DescripcionRegreso =  Tmpc.MotivoRechaDevolucion;

       -- Nombre Sucursal
	   	UPDATE MONITORCONSULTAGLOBAL T,
		       SUCURSALES  S
		SET T.NombreSucursal = S.NombreSucurs
		WHERE T.Transaccion = Aud_NumTransaccion
		AND  T.SucursalID=S.SucursalID;

		-- Producto Credito
		UPDATE MONITORCONSULTAGLOBAL T,
		       PRODUCTOSCREDITO  P
		SET T.DescProductoCre = P.Descripcion
		WHERE T.Transaccion = Aud_NumTransaccion
		AND  T.ProductoCreditoID=P.ProducCreditoID;

		-- Monto otorgado
		UPDATE MONITORCONSULTAGLOBAL T,
		       SOLICITUDCREDITO  S
		SET T.MontoCredito = CASE WHEN S.Estatus=Est_SolLib
									THEN S.MontoSolici
									ELSE S.MontoAutorizado
			                 END
		WHERE T.Transaccion = Aud_NumTransaccion
		AND  T.SolicitudCreditoID=S.SolicitudCreditoID;

		-- Fecha Comentario
		UPDATE MONITORCONSULTAGLOBAL T,
				COMENTARIOSSOL C
		SET T.Fecha			= C.Fecha
		WHERE T.Transaccion = Aud_NumTransaccion
        AND T.SolicitudCreditoID = C.SolicitudCreditoID
        AND T.Estatus = C.Estatus
        AND T.SolicitudCreditoID != Entero_Cero;

        -- Fecha Comentario
		UPDATE MONITORCONSULTAGLOBAL T,
				COMENTARIOSSOL C
		SET T.Fecha			= C.Fecha
		WHERE T.Transaccion = Aud_NumTransaccion
        AND T.CreditoID = C.SolicitudCreditoID
        AND T.Estatus = C.Estatus
        AND T.SolicitudCreditoID = Entero_Cero;


		UPDATE MONITORCONSULTAGLOBAL M,
				CREDITOS C
        SET M.CreditoID = C.CreditoID
        WHERE M.Transaccion = Aud_NumTransaccion
        AND M.SolicitudCreditoID = C.SolicitudCreditoID
        AND M.SolicitudCreditoID != Entero_Cero;

        UPDATE MONITORCONSULTAGLOBAL M,
				SOLICITUDCREDITO S
		SET M.Comentario = CASE WHEN IFNULL(M.CreditoID, "") = "" THEN S.ComentarioEjecutivo
									ELSE S.ComentarioMesaControl
							END
		WHERE M.Transaccion = Aud_NumTransaccion
        AND M.SolicitudCreditoID = S.SolicitudCreditoID
        AND M.SolicitudCreditoID != Entero_Cero;


        UPDATE MONITORCONSULTAGLOBAL M,
				SOLICITUDESCERO S
		SET M.Comentario = S.ComentarioMesaControl
		WHERE M.Transaccion = Aud_NumTransaccion
        AND M.CreditoID = S.CreditoID
        AND M.SolicitudCreditoID = Entero_Cero;

        -- Consulta Datos de acuerdo al Estatus seleccionado

		SET Var_Sentencia := CONCAT('
			(SELECT Tmp.SolicitudCreditoID,	IFNULL(Tmp.CreditoID,0) AS CreditoID,	Tmp.ClienteID,	Tmp.ProspectoID,
					IF(Tmp.ClienteID = 0, 	Tmp.NombreProspecto,	NombreCompleto) AS NombreCompleto,
					Tmp.PromotorID,			Tmp.NombrePromotor,		Tmp.UsuarioID,	Tmp.NombreUsuario,	Tmp.Comentario,
					Tmp.Fecha,              Tmp.ClaveUsuario AS ClaveAnalista,      Tmp.UsuarioIDAnalista,    Tmp.MotivoRechazoID,
					Tmp.DescripcionRegreso, Tmp.EstatusSolicitud AS EstatusSolicitud,  Tmp.NombreSucursal,
					Tmp.ProductoCreditoID,  Tmp.DescProductoCre AS DescripcionProducto,  Tmp.MontoCredito AS MontoOtorgado,Tmp.TipoAsignacionID
			FROM MONITORCONSULTAGLOBAL Tmp');
		SET Var_Sentencia	:= CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO P ON P.ProducCreditoID=Tmp.ProductoCreditoID');

	    SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND P.RequiereAnalisiCre = "', Var_NO,'"');
	    SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND  Tmp.Transaccion =', Aud_NumTransaccion );
        -- Filtro por Estatus de la Solicitud
        IF  (IFNULL(Par_Estatus,Cadena_Vacia) != Cadena_Vacia ) THEN
			SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	Tmp.Estatus = "', Par_Estatus,'"');
		END IF;
		SET Var_Sentencia	:= CONCAT(Var_Sentencia,	') UNION (SELECT Tmp.SolicitudCreditoID,	IFNULL(Tmp.CreditoID,0) AS CreditoID,	Tmp.ClienteID,	Tmp.ProspectoID,
					IF(Tmp.ClienteID = 0, 	Tmp.NombreProspecto,	NombreCompleto) AS NombreCompleto,
					Tmp.PromotorID,			Tmp.NombrePromotor,		Tmp.UsuarioID,	Tmp.NombreUsuario,	Tmp.Comentario,
					Tmp.Fecha,              Tmp.ClaveUsuario AS ClaveAnalista,      Tmp.UsuarioIDAnalista,    Tmp.MotivoRechazoID,
					Tmp.DescripcionRegreso, Tmp.EstatusSolicitud AS EstatusSolicitud,  Tmp.NombreSucursal,
					Tmp.ProductoCreditoID,  Tmp.DescProductoCre AS DescripcionProducto,  Tmp.MontoCredito AS MontoOtorgado,Tmp.TipoAsignacionID
			FROM MONITORCONSULTAGLOBAL Tmp');
				SET Var_Sentencia	:= CONCAT(Var_Sentencia,' INNER JOIN SOLICITUDESASIGNADAS S ON S.SolicitudCreditoID=Tmp.SolicitudCreditoID');

	    SET Var_Sentencia	:= CONCAT(Var_Sentencia,' WHERE S.UsuarioID=Tmp.UsuarioConsulta ');

	    SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND  Tmp.Transaccion =', Aud_NumTransaccion );
        -- Filtro por Estatus de la Solicitud

        IF  (IFNULL(Par_Estatus,Cadena_Vacia) != Cadena_Vacia ) THEN
			SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	Tmp.Estatus = "', Par_Estatus,'"');
		END IF;


		SET Var_Sentencia	:= CONCAT(Var_Sentencia,');');

		SET @Sentencia	= (Var_Sentencia);

		PREPARE STDETALLESOLICITUD FROM @Sentencia;
		EXECUTE STDETALLESOLICITUD;
		DEALLOCATE PREPARE STDETALLESOLICITUD;

	END IF;

     -- Lista cantidad de Solicitudes generadas en Sucursal, Banca Movil  y Banca en Línea
    IF(Par_NumLis = Lis_CanalIngreso) THEN

		SET Var_Sentencia := CONCAT('
				SELECT COUNT(CanalIngreso) CanalIngreso, CASE CanalIngreso
											WHEN "',Sucursal,'" THEN "',SucursalTxt,'"
											WHEN "',BancaMovil,'" THEN "',BancaMovilTxt,'"
											WHEN "',BancaLinea,'" THEN "',BancaLineaTxt,'"
											END AS TipoCanal
				FROM MONITORCONSULTAGLOBAL Tmp
				WHERE Tmp.Transaccion =', Aud_NumTransaccion);

            -- Filtro por Estatus de la Solicitud

        IF  (IFNULL(Par_Estatus,Cadena_Vacia) != Cadena_Vacia ) THEN
			SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	Tmp.Estatus = "', Par_Estatus,'"');
		END IF;

		SET Var_Sentencia	:= CONCAT(Var_Sentencia,' GROUP BY TipoCanal');

		SET Var_Sentencia	:= CONCAT(Var_Sentencia,';');

		SET @Sentencia	= (Var_Sentencia);

		PREPARE STCANALINGRESO FROM @Sentencia;
		EXECUTE STCANALINGRESO;
		DEALLOCATE PREPARE STCANALINGRESO;

	END IF;

	-- Lista Detalle de las Solicitudes Condicionadas
    IF(Par_NumLis = Lis_DetalleSolicitudesCC) THEN

		-- ACTUALIZACION DE CAMPOS

		-- Cliente
		UPDATE  MONITORCONSULTAGLOBAL T,
				CLIENTES C
		SET T.NombreCompleto = C.NombreCompleto
		WHERE T.Transaccion = Aud_NumTransaccion
		AND T.ClienteID=C.ClienteID;

		-- Prospecto
		UPDATE MONITORCONSULTAGLOBAL T,
				PROSPECTOS P
		SET T.NombreProspecto = P.NombreCompleto
		WHERE T.Transaccion = Aud_NumTransaccion
        AND T.ProspectoID = P.ProspectoID;

		-- Promotores
		UPDATE MONITORCONSULTAGLOBAL T,
				PROMOTORES P
		SET T.NombrePromotor = P.NombrePromotor
		WHERE T.Transaccion = Aud_NumTransaccion
        AND T.PromotorID = P.PromotorID;

		-- Usuarios
		UPDATE MONITORCONSULTAGLOBAL T,
				USUARIOS U
		SET T.NombreUsuario = U.NombreCompleto
		WHERE T.Transaccion = Aud_NumTransaccion
        AND T.UsuarioID = U.UsuarioID ;

		-- Comentarios
		UPDATE MONITORCONSULTAGLOBAL T,
				COMENTARIOSSOL C
		SET	T.Fecha			= C.Fecha
		WHERE T.Transaccion = Aud_NumTransaccion
        AND T.SolicitudCreditoID = C.SolicitudCreditoID
		AND T.Estatus = C.Estatus
		AND T.SolicitudCreditoID != Entero_Cero;

         -- Comentarios
		UPDATE MONITORCONSULTAGLOBAL T,
				COMENTARIOSSOL C
		SET T.Fecha			= C.Fecha
		WHERE T.Transaccion = Aud_NumTransaccion
        AND T.CreditoID = C.SolicitudCreditoID
        AND T.Estatus = C.Estatus
        AND T.SolicitudCreditoID = Entero_Cero;


        UPDATE MONITORCONSULTAGLOBAL M,
				CREDITOS C
        SET M.CreditoID = C.CreditoID
        WHERE M.Transaccion = Aud_NumTransaccion
        AND M.SolicitudCreditoID = C.SolicitudCreditoID
        AND M.SolicitudCreditoID != Entero_Cero;


        UPDATE MONITORCONSULTAGLOBAL M,
				SOLICITUDCREDITO S
		SET M.Comentario = CASE WHEN IFNULL(M.CreditoID, "") = "" THEN S.ComentarioEjecutivo
									ELSE S.ComentarioMesaControl
							END
		WHERE M.Transaccion = Aud_NumTransaccion
        AND M.SolicitudCreditoID = S.SolicitudCreditoID
        AND M.SolicitudCreditoID != Entero_Cero;


        UPDATE MONITORCONSULTAGLOBAL M,
				SOLICITUDESCERO S
		SET M.Comentario = S.ComentarioMesaControl
		WHERE M.Transaccion = Aud_NumTransaccion
        AND M.CreditoID = S.CreditoID
        AND M.SolicitudCreditoID = Entero_Cero;


        SET Var_Sentencia := CONCAT('
			SELECT Tmp.SolicitudCreditoID,	IFNULL(Tmp.CreditoID,0) AS CreditoID,			Tmp.ClienteID,	Tmp.ProspectoID,
					IF(Tmp.ClienteID = 0, 	Tmp.NombreProspecto,	NombreCompleto) AS NombreCompleto,
					Tmp.PromotorID,			Tmp.NombrePromotor,		Tmp.UsuarioID,	Tmp.NombreUsuario,	Tmp.Comentario,
					Tmp.Fecha,
                    Tmp.NombreSucursal, Tmp.DescProductoCre AS DescripcionProducto, MontoCredito AS MontoOtorgado,
                    Tmp.ClaveUsuario AS ClaveAnalista, Tmp.UsuarioIDAnalista,    Tmp.MotivoRechazoID,
                    Tmp.DescripcionRegreso, Tmp.EstatusSolicitud AS EstatusSolicitud,  Tmp.NombreSucursal,
                    Tmp.ProductoCreditoID,  TipoAsignacionID
			FROM MONITORCONSULTAGLOBAL Tmp
            WHERE Tmp.Transaccion =', Aud_NumTransaccion);

        -- Filtro por Estatus
        IF  (IFNULL(Par_Estatus,Cadena_Vacia) != Cadena_Vacia ) THEN
			SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND	Tmp.Estatus = "', Par_Estatus,'"');
		END IF;

		SET Var_Sentencia	:= CONCAT(Var_Sentencia,';');

		SET @Sentencia	= (Var_Sentencia);

		PREPARE STDETALLESOLICITUD FROM @Sentencia;
		EXECUTE STDETALLESOLICITUD;
		DEALLOCATE PREPARE STDETALLESOLICITUD;

	END IF;

END TerminaStore$$
