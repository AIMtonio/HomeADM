-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLCONFIGSERVICIOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLCONFIGSERVICIOLIS`;DELIMITER $$

CREATE PROCEDURE `PSLCONFIGSERVICIOLIS`(
#	-- Stored procedure para listar la configuracion de los Servicios en Linea
	Par_ServicioID 					INT(11), 				-- ID del servicio
	Par_Servicio 					VARCHAR(100), 			-- Nombre del servicio
	Par_ClasificacionServ 			CHAR(2), 				-- Clasificacion del servicio (RE = Recarga de tiempo aire, CO = Consulta de saldo, PS = Pago de servicios)

	Par_NumLis						TINYINT UNSIGNED,		-- Numero de lista

	Aud_EmpresaID					INT(11),				-- Parametro de auditoria
	Aud_Usuario						INT(11),				-- Parametro de auditoria
	Aud_FechaActual					DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP					VARCHAR(15),    		-- Parametro de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal					INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametro de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT;					-- Entero vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Lis_DescServicios		TINYINT;				-- Opcion para devolver todos los servicios y sus clasificaciones
	DECLARE Lis_ClasificacionServ	TINYINT;				-- Opcion para devolver las distintas clasificaciones de servicio
	DECLARE Lis_Servicios 			TINYINT;				-- Opcion para devolver los distintos servicios
	DECLARE Lis_ServiciosClasif		TINYINT;				-- Opcion para devolver los servicios por su clasificacion
	DECLARE Est_Activo 				CHAR(1);				-- Estatus activo
	DECLARE Var_TipoFront1			INT(11);				-- TipoFront = 1 para las validaciones de tipoReferencia = ""
	DECLARE Var_TipoFront2			INT(11);				-- TipoFront = 2 para las validaciones de precio = 0.0
	DECLARE Var_TipoFront4			INT(11);				-- TipoFront = 4 para las validaciones de precio = 0.0
	DECLARE Var_TipoFront6			INT(11);				-- TipoFront = 6 para las validaciones de precio = 0.0
	DECLARE Var_TipoFront10			INT(11);				-- TipoFront = 10 para las validaciones de tipoReferencia = ""
	DECLARE Var_ClasificacionRE 	CHAR(2); 				-- Clasificacion para Recarga de tiempo aire
	DECLARE Var_ClasificacionCO 	CHAR(2); 				-- Clasificacion para Consulta de Saldo
	DECLARE Var_ClasificacionPS 	CHAR(2); 				-- Clasificacion para Pago de servicios

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Lis_DescServicios			:= 1;					-- Opcion para devolver todos los servicios y sus clasificaciones
	SET Lis_ClasificacionServ 		:= 2;					-- Opcion para devolver las distintas clasificaciones de servicio
	SET Lis_Servicios				:= 3;					-- Opcion para devolver los distintos servicios
	SET Lis_ServiciosClasif			:= 4;					-- Opcion para devolver los servicios por su clasificacion
	SET Est_Activo 					:= 'A';					-- Estatus activo
	SET Var_TipoFront1				:= 1;					-- Asignacion de TipoFront = 1
	SET Var_TipoFront2				:= 2;					-- Asignacion de TipoFront = 2
	SET Var_TipoFront4				:= 4;					-- Asignacion de TipoFront = 4
	SET Var_TipoFront6				:= 6;					-- Asignacion de TipoFront = 6
	SET Var_TipoFront10				:= 10;					-- Asignacion de TipoFront = 10
	SET Var_ClasificacionRE 		:= 'RE'; 				-- Clasificacion para Recarga de tiempo aire
	SET Var_ClasificacionCO 		:= 'CO'; 				-- Clasificacion para Consulta de Saldo
	SET Var_ClasificacionPS 		:= 'PS'; 				-- Clasificacion para Pago de servicios

	-- Valores por default
	SET Par_NumLis					:= IFNULL(Par_NumLis,Entero_Cero);

	-- LISTA DE LOS SERVICIOS CON SU CLASIFICACION DE SERVICIO
	IF(Par_NumLis = Lis_DescServicios) THEN
		-- Temporal con los distintos tipos de servicios
		DROP TABLE IF EXISTS TMPSERVICIO;
		CREATE TEMPORARY TABLE TMPSERVICIO (
			ServicioID 			INT(11),
			Servicio 			VARCHAR(200),

			PRIMARY KEY(ServicioID),
			INDEX `INDEX_TMPSERVICIO_1` (`ServicioID` ASC)
		);

		INSERT INTO TMPSERVICIO (ServicioID, Servicio)
			SELECT ServicioID, Servicio
				FROM PSLPRODBROKER
				GROUP BY ServicioID;

		-- Temporal con las distintas clasificaciones de servicio
		DROP TABLE IF EXISTS TMPCLASIFICACIONSERV;
		CREATE TEMPORARY TABLE TMPCLASIFICACIONSERV (
			ClasificacionServ 			CHAR(2),
			NomClasificacion 			VARCHAR(50),

			PRIMARY KEY(ClasificacionServ),
			INDEX `INDEX_TMPSERVICIO_1` (`ClasificacionServ` ASC)
		);

		INSERT INTO TMPCLASIFICACIONSERV (ClasificacionServ, NomClasificacion) VALUES('RE', 'RECARGA');
		INSERT INTO TMPCLASIFICACIONSERV (ClasificacionServ, NomClasificacion) VALUES('CO', 'CONSULTA DE SALDO');
		INSERT INTO TMPCLASIFICACIONSERV (ClasificacionServ, NomClasificacion) VALUES('PS', 'PAGO DE SERVICIO');

		SELECT	PSLCONFIGSERVICIO.ServicioID, 	TMPSERVICIO.Servicio, 	PSLCONFIGSERVICIO.ClasificacionServ, TMPCLASIFICACIONSERV.NomClasificacion
			FROM PSLCONFIGSERVICIO
			INNER JOIN TMPSERVICIO ON TMPSERVICIO.ServicioID = PSLCONFIGSERVICIO.ServicioID
			INNER JOIN TMPCLASIFICACIONSERV ON TMPCLASIFICACIONSERV.ClasificacionServ = PSLCONFIGSERVICIO.ClasificacionServ
			WHERE PSLCONFIGSERVICIO.Estatus = Est_Activo
			ORDER BY TMPSERVICIO.Servicio;

		DROP TABLE IF EXISTS TMPSERVICIO;
		DROP TABLE IF EXISTS TMPCLASIFICACIONSERV;
	END IF;

	-- LISTA DE LAS DISTINTAS CLASIFICACIONES DE SERVICIOS
	IF(Par_NumLis = Lis_ClasificacionServ) THEN
		-- Temporal con las distintas clasificaciones de servicio
		DROP TABLE IF EXISTS TMPCLASIFICACIONSERV;
		CREATE TEMPORARY TABLE TMPCLASIFICACIONSERV (
			ClasificacionServ 			CHAR(2),
			NomClasificacion 			VARCHAR(50),

			PRIMARY KEY(ClasificacionServ),
			INDEX `INDEX_TMPSERVICIO_1` (`ClasificacionServ` ASC)
		);

		INSERT INTO TMPCLASIFICACIONSERV (ClasificacionServ, NomClasificacion) VALUES('RE', 'RECARGA');
		INSERT INTO TMPCLASIFICACIONSERV (ClasificacionServ, NomClasificacion) VALUES('CO', 'CONSULTA DE SALDO');
		INSERT INTO TMPCLASIFICACIONSERV (ClasificacionServ, NomClasificacion) VALUES('PS', 'PAGO DE SERVICIO');

		SELECT ClasificacionServ, NomClasificacion
			FROM TMPCLASIFICACIONSERV;

		DROP TABLE IF EXISTS TMPCLASIFICACIONSERV;
	END IF;

	-- LISTA DE LOS DISTINTOS SERVICIOS
	IF(Par_NumLis = Lis_Servicios) THEN
		SELECT ServicioID, Servicio
			FROM PSLPRODBROKER
			GROUP BY ServicioID;
	END IF;

	-- LISTA DE SERVICIOS POR CLASIFICACION
	IF(Par_NumLis = Lis_ServiciosClasif) THEN
		SELECT ServicioID, Servicio
			FROM PSLPRODBROKER
			WHERE ClasificacionServ = Par_ClasificacionServ
			GROUP BY ServicioID;
	END IF;

-- Fin del SP
END TerminaStore$$