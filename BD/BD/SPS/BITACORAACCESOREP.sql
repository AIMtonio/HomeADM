-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAACCESOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAACCESOREP`;DELIMITER $$

CREATE PROCEDURE `BITACORAACCESOREP`(
# =====================================================================================
# ------- STORED PARA REPORTE DE LA BITACORA DE ACCESOS AL SAFI---------
# =====================================================================================
    Par_FechaInicio			DATE,			-- Fecha de inicio
	Par_FechaFin			DATE,			-- Fecha de Fin
    Par_UsuarioID			INT(11),		-- ID del usuario
    Par_SucursalID			INT(11),		-- ID de la sucursal
    Par_TipoAcceso			INT(11),	  	-- Tipo de acceso 1= Acceso exitoso, 2=Acceso fallido, 3= Acceso Recursos

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES

	DECLARE Var_Sentencia		VARCHAR(6000);		-- Sentencia SQL
    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
	DECLARE	Var_FechaSist		DATE; 				-- Fecha del sistema
	DECLARE	Var_TipoDetRecursos	INT(11); 			-- Indica el tipo de detalle que se mostrara en el reporte bitacora de accesos 1= mostrara ruta safi, 2= nombre del recurso
    DECLARE Var_InstitucionID	INT(11);			-- ID de institucion
	DECLARE Var_TipoInstitID	INT(11);			-- ID tipo de institucion
    DECLARE Var_Safilocale		VARCHAR(10);		-- Define si la institución tiene socios o clientes

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno

    -- ASIGNACIŃ DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;

	SELECT FechaSistema, TipoDetRecursos,	InstitucionID
		INTO Var_FechaSist, Var_TipoDetRecursos,	Var_InstitucionID
    FROM PARAMETROSSIS
    LIMIT 1;

    -- tipo de institucion
    SET Var_TipoInstitID :=(SELECT TipoInstitID FROM INSTITUCIONES WHERE InstitucionID = Var_InstitucionID);

    IF(Var_TipoInstitID = 6)THEN
		SET Var_Safilocale :="Socio";
    ELSE
		SET Var_Safilocale :="Cliente";
    END IF;

	DROP TABLE IF EXISTS TMPREPBITACORAACCESOS;
		CREATE TEMPORARY TABLE TMPREPBITACORAACCESOS(
			Fecha				DATE,
			Hora				TIME,
			Claveusuario		VARCHAR(45),
            DireccionIP			VARCHAR(20),
            DetalleAcceso		VARCHAR(500),
            SucursalID			INT(11),
            NombreSucursal		VARCHAR(50),
            UsuarioID			INT(11),
            NombreUsuario		VARCHAR(160),
            RolID				INT(11),
            Perfil				VARCHAR(50),
            Recurso				VARCHAR(45),
            KEY `idx_TMPREPBITACORAACCESOS_1`(`SucursalID` ASC),
            KEY `idx_TMPREPBITACORAACCESOS_2`(`UsuarioID` ASC),
            KEY `idx_TMPREPBITACORAACCESOS_3`(`RolID` ASC),
            KEY `idx_TMPREPBITACORAACCESOS_4`(`Recurso` ASC)
		);

    -- Cuando la fecha del sistema esta dentro del rango consultara a la tabla BITACORAACCESO
    IF(Var_FechaSist >= Par_FechaInicio AND Var_FechaSist <= Par_FechaFin)THEN


		SET Var_Sentencia := CONCAT("INSERT INTO TMPREPBITACORAACCESOS(
					Fecha, 			Hora, 			ClaveUsuario,		DireccionIP,		DetalleAcceso,
                    SucursalID,		NombreSucursal,	UsuarioID,			NombreUsuario,		RolID,
                    Perfil,			Recurso
			)
			SELECT
					bita.Fecha,		bita.Hora, 		bita.ClaveUsuario,	bita.AccesoIP, 		bita.DetalleAcceso,
                    bita.SucursalID, '',			bita.UsuarioID,		'',					bita.Perfil,
                    '',				bita.Recurso
			FROM BITACORAACCESO bita
				WHERE bita.Fecha BETWEEN '",Par_FechaInicio,"' AND '",Par_FechaFin,"' ");

		-- Filtro por usuario
		IF(Par_UsuarioID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND bita.UsuarioID = ",Par_UsuarioID);
		END IF;

		-- Filtro por sucursal
		IF(Par_SucursalID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND bita.SucursalID = ",Par_SucursalID);
		END IF;

		-- Filtro por tipo de acceso
		IF(Par_TipoAcceso > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND bita.TipoAcceso = ",Par_TipoAcceso);
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia, "  ORDER BY bita.Fecha, bita.Hora ");

		SET Var_Sentencia := CONCAT(Var_Sentencia, " ;    ");

        SET @Sentencia	= (Var_Sentencia);
		PREPARE BITACORAACCESOSREP FROM @Sentencia;
		EXECUTE BITACORAACCESOSREP;
		DEALLOCATE PREPARE BITACORAACCESOSREP;
    END IF;

    -- Cuando el rango de fechas es menor a la fecha del sistema consultara a la tabla HISBITACORAACCESO
    IF(Par_FechaInicio < Var_FechaSist)THEN

		SET Var_Sentencia := CONCAT("INSERT INTO TMPREPBITACORAACCESOS(
					Fecha, 			Hora, 			ClaveUsuario,		DireccionIP,		DetalleAcceso,
                    SucursalID,		NombreSucursal,	UsuarioID,			NombreUsuario,		RolID,
                    Perfil,			Recurso
			)
			SELECT
					bita.Fecha,		bita.Hora, 		bita.ClaveUsuario,	bita.AccesoIP, 		bita.DetalleAcceso,
                    bita.SucursalID, '',			bita.UsuarioID,		'',					bita.Perfil,
                    '',				bita.Recurso
			FROM HISBITACORAACCESO bita
				WHERE bita.Fecha BETWEEN '",Par_FechaInicio,"' AND '",Par_FechaFin,"' ");

		-- Filtro por usuario
		IF(Par_UsuarioID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND bita.UsuarioID = ",Par_UsuarioID);
		END IF;

		-- Filtro por sucursal
		IF(Par_SucursalID > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND bita.SucursalID = ",Par_SucursalID);
		END IF;

		-- Filtro por tipo de acceso
		IF(Par_TipoAcceso > Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, " AND bita.TipoAcceso = ",Par_TipoAcceso);
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia, "  ORDER BY bita.Fecha, bita.Hora ");

		SET Var_Sentencia := CONCAT(Var_Sentencia, " ;    ");

		SET @Sentencia	= (Var_Sentencia);
		PREPARE BITACORAACCESOSREP FROM @Sentencia;
		EXECUTE BITACORAACCESOSREP;
		DEALLOCATE PREPARE BITACORAACCESOSREP;

    END IF;

    UPDATE TMPREPBITACORAACCESOS tmp, SUCURSALES suc
		SET tmp.NombreSucursal = suc.NombreSucurs
	WHERE tmp.SucursalID = suc.SucursalID;

    UPDATE TMPREPBITACORAACCESOS tmp, USUARIOS usu
		SET tmp.NombreUsuario = usu.NombreCompleto
	WHERE tmp.UsuarioID = usu.UsuarioID;

    UPDATE TMPREPBITACORAACCESOS tmp, ROLES rol
		SET tmp.Perfil = rol.NombreRol
	WHERE tmp.RolID = rol.RolID;

    -- CUANDO SE PARAMETRIZO EN PARAMETROS GENERALES QUE EL NIVEL DE DETALLE ES 1
	-- SE DEBE MOSTRAR LA RUTA DE LA PANTALLA
    IF(Var_TipoDetRecursos = Entero_Uno)THEN

		UPDATE TMPREPBITACORAACCESOS tmp, OPCIONESMENU opc,
				GRUPOSMENU gru, MENUSAPLICACION men
			SET tmp.DetalleAcceso = CONCAT("Pantalla: ",CASE WHEN men.Desplegado = "safilocale.cliente" THEN Var_Safilocale
															 WHEN men.Desplegado = "safilocale.cuentascte" THEN CONCAT("Cuentas " ,Var_Safilocale)
															 ELSE men.Desplegado END,
														" -> ",gru.Desplegado," -> ",
                                                        CASE WHEN opc.Desplegado = "safilocale.cliente" THEN Var_Safilocale
															 WHEN opc.Desplegado = "safilocale.expcte" THEN CONCAT("Expediente " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.conocte" THEN CONCAT("Conocimiento del " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.ctaAhorro" THEN "Cuenta"
															 WHEN opc.Desplegado = "safilocale.poscte" THEN CONCAT("Posicion " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.ctascte" THEN CONCAT("Cuentas por " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.rescte" THEN CONCAT("Resumen " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.invcte" THEN CONCAT("Inv. por " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.fotocte" THEN CONCAT("Foto " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.perfcte" THEN CONCAT("Perfil " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.relcte" THEN CONCAT("Relaciones " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.perfcte" THEN CONCAT("Perfil " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.actinacte" THEN CONCAT("Activa/Inactiva " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.segcte" THEN CONCAT("Seguro " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.identiRepCte" THEN CONCAT("Reporte de Identificacion del " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.cteMen" THEN CONCAT("Reporte ",Var_Safilocale," Menor" )
															 WHEN opc.Desplegado = "safilocale.ctaAhorroRep" THEN "Movimientos de Cuenta"
															 WHEN opc.Desplegado = "safilocale.fjoCte" THEN CONCAT("Flujo " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.cancelCteAtencion" THEN CONCAT("Cancelar ",Var_Safilocale," Por Atencion a " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.califCte" THEN CONCAT("Calificacion de " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.cambioSucursalCli" THEN CONCAT("Cambio Sucursal al " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.cancelCteProtec" THEN CONCAT("Cancelar ",Var_Safilocale," Por Protecciones" )
															 WHEN opc.Desplegado = "safilocale.cancelCteCobranza" THEN CONCAT("Cancelar ",Var_Safilocale," Por Cobranza" )
															 WHEN opc.Desplegado = "safilocale.hisCarteraCliente" THEN CONCAT("Historico de Cartera por " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.edoCta" THEN CONCAT("Edo. Cta. " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.cteAltoRiesgo" THEN CONCAT(Var_Safilocale," Alto Riesgo")
															 WHEN opc.Desplegado = "safilocale.cteSinActCrediticia" THEN CONCAT(Var_Safilocale," Sin Actividad Crediticia")
															 WHEN opc.Desplegado = "safilocale.referenciasCte" THEN CONCAT("Referencias del" ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.nivelRiesgoCte" THEN CONCAT("Nivel de Riesgo por " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.riesgoActualCte" THEN CONCAT("Riesgo Actual del " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.hisRiesCte" THEN CONCAT("Historico de Riesgo por " ,Var_Safilocale)
															 WHEN opc.Desplegado = "safilocale.clienteListasPLD" THEN CONCAT(Var_Safilocale," en Listas")
															 ELSE opc.Desplegado END )
		WHERE tmp.Recurso = opc.Recurso
			AND opc.GrupoMenuID = gru.GrupoMenuID
			AND gru.MenuID = men.MenuID;
    END IF;


    SELECT 	Fecha, 			Hora, 			ClaveUsuario,		DireccionIP,		DetalleAcceso,
			NombreSucursal,	NombreUsuario,	Perfil
    FROM TMPREPBITACORAACCESOS
		ORDER BY Fecha,Hora ;

END TerminaStore$$