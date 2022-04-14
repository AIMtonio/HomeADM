DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDSEGUIMIENTOPERSONAREP`;
DELIMITER $$
CREATE PROCEDURE `PLDSEGUIMIENTOPERSONAREP`(
	Par_FechaInicio			DATE,		-- Fecha de inicio de la deteccion de las listas
	Par_FechaFin			DATE,		-- Fecha de fin de la deteccion en las listas
	Par_Operaciones			CHAR(1),	-- Operaciones de: C = CLIENTES, U = USUARIOS DE SERVICIOS, "" = TODOS
	Par_TipoReporte			INT(11),	-- Tipo de reporte a generar

	Par_EmpresaID			INT(11),	-- Parametro de auditoria
	Aud_Usuario				INT(11),	-- Parametro de auditoria
	Aud_FechaActual			DATETIME,	-- Parametros de auditoria
	Aud_DireccionIP			VARCHAR(15),-- Parametros de auditoria
	Aud_ProgramaID			VARCHAR(50),-- Parametro de auditoria
	Aud_Sucursal			INT(11),	-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)	-- Parametro de audotiria
)
TerminaStore:BEGIN

	-- Declaracion de variables

	-- Declaracion de constantes
	DECLARE Con_Excel		INT(11);
	DECLARE Entero_Cero		INT(11);
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Fecha_Vacia		DATE;
	DECLARE Con_LPB			CHAR(3);
	DECLARE Con_LPBTXT		VARCHAR(45);
	DECLARE Con_CTE			CHAR(3);
	DECLARE Con_NA 			CHAR(2);
	DECLARE Con_PRO			CHAR(3);
	DECLARE Con_AVA 		CHAR(3);
	DECLARE Con_REL 		CHAR(3);
	DECLARE Con_USU			CHAR(3);
	DECLARE Con_PRV 		CHAR(3);
	DECLARE Con_OBS			CHAR(3);
	DECLARE Con_NoAplica	VARCHAR(9);

	DECLARE Con_SI 			CHAR(1);
	DECLARE Con_SITXT 		CHAR(2);
	DECLARE Con_NOTXT		CHAR(2);
	DECLARE OperaClientes	CHAR(1);
    DECLARE OperaUsuarios	CHAR(1);

	-- Seteo de valores
	SET Con_Excel 			:= 1;
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Con_LPB 			:= 'LPB';
	SET Con_LPBTXT 			:= 'LISTA DE PERSONAS BLOQUEADAS';
	SET Con_CTE 			:= 'CTE';
	SET Con_NA 				:= 'NA';
	SET Con_PRO 			:= 'PRO';
	SET Con_AVA 			:= 'AVA';
	SET Con_REL 			:= 'REL';
	SET Con_USU 			:= 'USU';
	SET Con_PRV 			:= 'PRV';
	SET Con_OBS 			:= 'OBS';

	SET Con_NoAplica		:= 'NO APLICA';

	SET Con_SI 				:= 'S';
	SET Con_SITXT			:= 'SI';
	SET Con_NOTXT 			:= 'NO';
	SET OperaClientes		:= 'C';
    SET OperaUsuarios		:= 'U';

	-- Consulta principal para la pantalla Seguimiento de personas en listas
	IF Par_TipoReporte = Con_Excel THEN
		-- Todas las Operaciones
		IF(Par_Operaciones = Cadena_Vacia)THEN
			SELECT 	SPL.OpeInusualID AS Folio,		SPL.NumRegistro AS NumCliente,	SPL.Nombre AS NombreCliente,	INU.FechaDeteccion,

					CASE SPL.ListaDeteccion WHEN Con_LPB THEN Con_LPBTXT END AS ListaDeteccion,-- Aca se iran agregando los otros tipos de listas

			CASE INU.TipoPersonaSAFI 	WHEN Con_CTE THEN ACTCTE.Descripcion
										WHEN Con_NA THEN Con_NoAplica
										WHEN Con_PRO THEN Con_NoAplica
										WHEN Con_AVA THEN Con_NoAplica
										WHEN Con_REL THEN Con_NoAplica
										WHEN Con_USU THEN Con_NoAplica
										WHEN Con_PRV THEN Con_NoAplica
										WHEN Con_OBS THEN Con_NoAplica
										ELSE Con_NoAplica END AS ActividadBMX,


			CASE SPL.PermiteOperacion WHEN Con_SI THEN CON_SITXT ELSE Con_NOTXT END AS PermiteOperacion,	IFNULL(SPL.Comentario,Cadena_Vacia) AS Comentario

			FROM PLDSEGPERSONALISTAS SPL
			INNER JOIN PLDOPEINUSUALES INU ON SPL.OpeInusualID = INU.OpeInusualID
			INNER JOIN PLDCOINCIDENCIAS CON ON INU.OpeInusualID = CON.OpeInusualID
			LEFT JOIN PLDLISTAPERSBLOQ BLOQ ON CON.PersonaBloqID = BLOQ.PersonaBloqID
			LEFT JOIN CATTIPOLISTAPLD CATB ON BLOQ.TipoLista = CATB.TipoListaID
			LEFT JOIN CLIENTES CLI ON SPL.NumRegistro = CLI.ClienteID
			LEFT JOIN ACTIVIDADESBMX ACTCTE ON CLI.ActividadBancoMX = ACTCTE.ActividadBMXID
			LEFT JOIN PROSPECTOS PROS ON SPL.NumRegistro = PROS.ProspectoID
			LEFT JOIN AVALES AVAL ON SPL.NumRegistro = AVAL.AvalID
			LEFT JOIN RELACIONADOSFISCALES REL ON SPL.NumRegistro = REL.RelacionadoFiscalID
			LEFT JOIN USUARIOS USU ON SPL.NumRegistro = USU.UsuarioID
			LEFT JOIN PROVEEDORES PROV ON SPL.NumRegistro = PROV.ProveedorID
			LEFT JOIN OBLIGADOSSOLIDARIOS OBS ON SPL.NumRegistro = OBS.OblSolidID

			WHERE SPL.FechaDeteccion BETWEEN Par_FechaInicio AND Par_FechaFin;
		END IF;

        -- Operaciones de Clientes
        IF(Par_Operaciones = OperaClientes)THEN
			SELECT 	SPL.OpeInusualID AS Folio,		SPL.NumRegistro AS NumCliente,	SPL.Nombre AS NombreCliente,	INU.FechaDeteccion,

					CASE SPL.ListaDeteccion WHEN Con_LPB THEN Con_LPBTXT END AS ListaDeteccion,-- Aca se iran agregando los otros tipos de listas

			CASE INU.TipoPersonaSAFI 	WHEN Con_CTE THEN ACTCTE.Descripcion
										WHEN Con_NA THEN Con_NoAplica
										WHEN Con_PRO THEN Con_NoAplica
										WHEN Con_AVA THEN Con_NoAplica
										WHEN Con_REL THEN Con_NoAplica
										WHEN Con_USU THEN Con_NoAplica
										WHEN Con_PRV THEN Con_NoAplica
										WHEN Con_OBS THEN Con_NoAplica
										ELSE Con_NoAplica END AS ActividadBMX,


			CASE SPL.PermiteOperacion WHEN Con_SI THEN CON_SITXT ELSE Con_NOTXT END AS PermiteOperacion,	IFNULL(SPL.Comentario,Cadena_Vacia) AS Comentario

			FROM PLDSEGPERSONALISTAS SPL
			INNER JOIN PLDOPEINUSUALES INU ON SPL.OpeInusualID = INU.OpeInusualID
			INNER JOIN PLDCOINCIDENCIAS CON ON INU.OpeInusualID = CON.OpeInusualID
			LEFT JOIN PLDLISTAPERSBLOQ BLOQ ON CON.PersonaBloqID = BLOQ.PersonaBloqID
			LEFT JOIN CATTIPOLISTAPLD CATB ON BLOQ.TipoLista = CATB.TipoListaID
			LEFT JOIN CLIENTES CLI ON SPL.NumRegistro = CLI.ClienteID
			LEFT JOIN ACTIVIDADESBMX ACTCTE ON CLI.ActividadBancoMX = ACTCTE.ActividadBMXID
			LEFT JOIN PROSPECTOS PROS ON SPL.NumRegistro = PROS.ProspectoID
			LEFT JOIN AVALES AVAL ON SPL.NumRegistro = AVAL.AvalID
			LEFT JOIN RELACIONADOSFISCALES REL ON SPL.NumRegistro = REL.RelacionadoFiscalID
			LEFT JOIN USUARIOS USU ON SPL.NumRegistro = USU.UsuarioID
			LEFT JOIN PROVEEDORES PROV ON SPL.NumRegistro = PROV.ProveedorID
			LEFT JOIN OBLIGADOSSOLIDARIOS OBS ON SPL.NumRegistro = OBS.OblSolidID

			WHERE SPL.FechaDeteccion BETWEEN Par_FechaInicio AND Par_FechaFin
            AND INU.TipoPersonaSAFI = 'CTE';
		END IF;

        -- Operaciones de Usuarios de Servicios
        IF(Par_Operaciones = OperaUsuarios)THEN
			SELECT 	SPL.OpeInusualID AS Folio,		SPL.NumRegistro AS NumCliente,	SPL.Nombre AS NombreCliente,	INU.FechaDeteccion,

					CASE SPL.ListaDeteccion WHEN Con_LPB THEN Con_LPBTXT END AS ListaDeteccion,-- Aca se iran agregando los otros tipos de listas

			CASE INU.TipoPersonaSAFI 	WHEN Con_CTE THEN ACTCTE.Descripcion
										WHEN Con_NA THEN Con_NoAplica
										WHEN Con_PRO THEN Con_NoAplica
										WHEN Con_AVA THEN Con_NoAplica
										WHEN Con_REL THEN Con_NoAplica
										WHEN Con_USU THEN Con_NoAplica
										WHEN Con_PRV THEN Con_NoAplica
										WHEN Con_OBS THEN Con_NoAplica
										ELSE Con_NoAplica END AS ActividadBMX,


			CASE SPL.PermiteOperacion WHEN Con_SI THEN CON_SITXT ELSE Con_NOTXT END AS PermiteOperacion,	IFNULL(SPL.Comentario,Cadena_Vacia) AS Comentario

			FROM PLDSEGPERSONALISTAS SPL
			INNER JOIN PLDOPEINUSUALES INU ON SPL.OpeInusualID = INU.OpeInusualID
			INNER JOIN PLDCOINCIDENCIAS CON ON INU.OpeInusualID = CON.OpeInusualID
			LEFT JOIN PLDLISTAPERSBLOQ BLOQ ON CON.PersonaBloqID = BLOQ.PersonaBloqID
			LEFT JOIN CATTIPOLISTAPLD CATB ON BLOQ.TipoLista = CATB.TipoListaID
			LEFT JOIN CLIENTES CLI ON SPL.NumRegistro = CLI.ClienteID
			LEFT JOIN ACTIVIDADESBMX ACTCTE ON CLI.ActividadBancoMX = ACTCTE.ActividadBMXID
			LEFT JOIN PROSPECTOS PROS ON SPL.NumRegistro = PROS.ProspectoID
			LEFT JOIN AVALES AVAL ON SPL.NumRegistro = AVAL.AvalID
			LEFT JOIN RELACIONADOSFISCALES REL ON SPL.NumRegistro = REL.RelacionadoFiscalID
			LEFT JOIN USUARIOS USU ON SPL.NumRegistro = USU.UsuarioID
			LEFT JOIN PROVEEDORES PROV ON SPL.NumRegistro = PROV.ProveedorID
			LEFT JOIN OBLIGADOSSOLIDARIOS OBS ON SPL.NumRegistro = OBS.OblSolidID

			WHERE SPL.FechaDeteccion BETWEEN Par_FechaInicio AND Par_FechaFin
            AND INU.TipoPersonaSAFI = 'USU';
		END IF;

	END IF;

END TerminaStore$$