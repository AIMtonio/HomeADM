-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRACTIVOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRACTIVOSCON`;DELIMITER $$

CREATE PROCEDURE `ARRACTIVOSCON`(
# =====================================================================================
# -- STORED PROCEDURE PARA CONSULTAR LOS ACTIVOS
# =====================================================================================
	Par_ActivoID			INT(11),			-- Numero de ID de un Activo
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta

	Par_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal			INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de Auditoria
	)
TerminaStore: BEGIN
	-- Declaracion de Variables

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
	DECLARE	Entero_Cero			INT(11);		-- Entero cero
	DECLARE	Decimal_Cero		DECIMAL(14,2);	-- Decimal cero

	DECLARE Con_Activos 	    INT(11);		-- Consulta de Activos por ID
	DECLARE Con_ActiInacti 	    INT(11);		-- Consulta de Activos e Inactivo por ID
	DECLARE Est_Activo			CHAR(1);		-- Indica el estatus activo A=activo
    DECLARE Est_Inactivo		CHAR(1);		-- Indica el estatus inactivo I=inactivo
    DECLARE Est_Ligado  		CHAR(1);		-- Indica el estatus ligado o asociado = L


	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';				-- Valor de cadena vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Valor de fecha vacia.
	SET	Entero_Cero				:= 0;				-- Valor de entero cero.
	SET	Decimal_Cero			:= 0.0;				-- Valor de decimal cero.

	SET Con_ActiInacti		    := 1;				-- Valor consulta 1
	SET Con_Activos             := 2;				-- Valor consulta 2
	SET Est_Activo			    := 'A';      		-- Estatus Activo=A
	SET Est_Inactivo			:= 'I';      		-- Estatus Inactivo=I
	SET Est_Ligado			    := 'L';      		-- Estatus Ligado=I


	-- Valores por Default
	SET Par_ActivoID			:= IFNULL(Par_ActivoID,Entero_Cero);
	SET Par_NumCon				:= IFNULL(Par_NumCon,Entero_Cero);


	-- Consulta 1 Activos e inactivo
	IF (Par_NumCon = Con_ActiInacti) THEN
        SELECT  activo.ActivoID,                          activo.Descripcion,        activo.TipoActivo,                 activo.SubtipoActivoID,            activo.Modelo,
                activo.MarcaID,                           activo.NumeroSerie,        activo.NumeroFactura,              activo.ValorFactura,               activo.CostosAdicionales,
                activo.FechaAdquisicion,                  activo.VidaUtil,           activo.PorcentDepreFis,            activo.PorcentDepreAjus,           activo.PlazoMaximo,
                activo.PorcentResidMax,                   activo.EstadoID,           activo.MunicipioID,                activo.LocalidadID,                activo.ColoniaID,
                activo.Calle,                             activo.NumeroCasa,         activo.NumeroInterior,             activo.Piso,                       activo.PrimerEntrecalle,
                activo.SegundaEntreCalle,                 activo.CP,                 activo.DireccionCompleta,          activo.Latitud,                    activo.Longitud,
                activo.Lote,                              activo.Manzana,            activo.DescripcionDom,             activo.AseguradoraID,              activo.EstaAsegurado,
                activo.NumPolizaSeguro,                   activo.FechaAdquiSeguro,   activo.InicioCoberSeguro,          activo.FinCoberSeguro,             activo.SumaAseguradora,
                activo.ValorDeduciSeguro,                 activo.Observaciones,      activo.Estatus,                    subtipo.Descripcion AS Subtipo,    marca.Descripcion AS Marca,
                aseguradora.Descripcion AS Aseguradora,   estado.Nombre AS Estado,   municipio.Nombre AS Municipio,     localidad.NombreLocalidad,         colonia.Asentamiento
			FROM ARRACTIVOS AS activo
			INNER JOIN ARRCSUBTIPOACTIVO AS subtipo ON subtipo.SubtipoActivoID = activo.SubtipoActivoID
			INNER JOIN ARRMARCAACTIVO AS marca ON marca.MarcaID = activo.MarcaID
			INNER JOIN ARRASEGURADORA AS aseguradora ON aseguradora.AseguradoraID = activo.AseguradoraID
			INNER JOIN ESTADOSREPUB AS estado ON estado.EstadoID = activo.EstadoID
			INNER JOIN MUNICIPIOSREPUB AS municipio ON municipio.MunicipioID = activo.MunicipioID
			  AND municipio.EstadoID = estado.EstadoID
			INNER JOIN LOCALIDADREPUB AS localidad ON localidad.LocalidadID = activo.LocalidadID
			  AND localidad.EstadoID = estado.EstadoID
			  AND localidad.MunicipioID = activo.MunicipioID
			INNER JOIN COLONIASREPUB AS colonia ON colonia.ColoniaID = activo.ColoniaID
			  AND colonia.EstadoID = estado.EstadoID
			  AND colonia.MunicipioID = activo.MunicipioID
			WHERE activo.ActivoID = Par_ActivoID
			   AND activo.Estatus IN (Est_Activo,Est_Inactivo,Est_Ligado);
	END IF;

    -- Consulta 2 Activos
	IF (Par_NumCon = Con_Activos) THEN
		SELECT  activo.ActivoID,                          activo.Descripcion,        activo.TipoActivo,                 activo.SubtipoActivoID,            activo.Modelo,
				activo.MarcaID,                           activo.NumeroSerie,        activo.NumeroFactura,              activo.ValorFactura,               activo.CostosAdicionales,
				activo.FechaAdquisicion,                  activo.VidaUtil,           activo.PorcentDepreFis,            activo.PorcentDepreAjus,           activo.PlazoMaximo,
				activo.PorcentResidMax,                   activo.EstadoID,           activo.MunicipioID,                activo.LocalidadID,                activo.ColoniaID,
				activo.Calle,                             activo.NumeroCasa,         activo.NumeroInterior,             activo.Piso,                       activo.PrimerEntrecalle,
				activo.SegundaEntreCalle,                 activo.CP,                 activo.DireccionCompleta,          activo.Latitud,                    activo.Longitud,
				activo.Lote,                              activo.Manzana,            activo.DescripcionDom,             activo.AseguradoraID,              activo.EstaAsegurado,
				activo.NumPolizaSeguro,                   activo.FechaAdquiSeguro,   activo.InicioCoberSeguro,          activo.FinCoberSeguro,             activo.SumaAseguradora,
				activo.ValorDeduciSeguro,                 activo.Observaciones,      activo.Estatus,                    subtipo.Descripcion AS Subtipo,    marca.Descripcion AS Marca,
				aseguradora.Descripcion AS Aseguradora,   estado.Nombre AS Estado,   municipio.Nombre AS Municipio,     localidad.NombreLocalidad,         colonia.Asentamiento
			FROM ARRACTIVOS AS activo
			INNER JOIN ARRCSUBTIPOACTIVO AS subtipo ON subtipo.SubtipoActivoID = activo.SubtipoActivoID
			INNER JOIN ARRMARCAACTIVO AS marca ON marca.MarcaID = activo.MarcaID
			INNER JOIN ARRASEGURADORA AS aseguradora ON aseguradora.AseguradoraID = activo.AseguradoraID
			INNER JOIN ESTADOSREPUB AS estado ON estado.EstadoID = activo.EstadoID
			INNER JOIN MUNICIPIOSREPUB AS municipio ON municipio.MunicipioID = activo.MunicipioID
			  AND municipio.EstadoID = estado.EstadoID
			INNER JOIN LOCALIDADREPUB AS localidad ON localidad.LocalidadID = activo.LocalidadID
			  AND localidad.EstadoID = estado.EstadoID
			  AND localidad.MunicipioID = activo.MunicipioID
			INNER JOIN COLONIASREPUB AS colonia ON colonia.ColoniaID = activo.ColoniaID
			  AND colonia.EstadoID = estado.EstadoID
			  AND colonia.MunicipioID = activo.MunicipioID
			WHERE activo.ActivoID = Par_ActivoID
			  AND activo.Estatus = Est_Activo;
	END IF;

	-- fin del sp
END TerminaStore$$