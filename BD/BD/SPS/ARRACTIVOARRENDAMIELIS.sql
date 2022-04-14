-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRACTIVOARRENDAMIELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRACTIVOARRENDAMIELIS`;DELIMITER $$

CREATE PROCEDURE `ARRACTIVOARRENDAMIELIS`(
# =====================================================================================
# -- STORED PROCEDURE PARA LISTAR LOS ACTIVOS QUE SE ENCUENTRAN LIGADOS A UN ARRENDAMIENTO
# =====================================================================================
	Par_ArrendaID			BIGINT(12),				-- Id del arrendamiento
    Par_NumLis				TINYINT UNSIGNED,		-- Numero de la lista

    Aud_EmpresaID			INT(11),				-- Id de la empresa
	Aud_Usuario				INT(11),				-- Usuario
	Aud_FechaActual			DATETIME,				-- Fecha actual
	Aud_DireccionIP 		VARCHAR(15),			-- Direccion IP
	Aud_ProgramaID 			VARCHAR(50),			-- Id del programa
	Aud_Sucursal 			INT(11),				-- Numero de sucursal
	Aud_NumTransaccion 		BIGINT(20)				-- Numero de transaccion
    )
TerminaStore: BEGIN

    -- Declaracion de constantes
    DECLARE Cadena_Vacia	CHAR(1);			-- Cadena vacia
    DECLARE	Fecha_Vacia		DATE;				-- Fecha Vacia
    DECLARE Entero_Cero		INT(11);			-- Constante de entero cero
	DECLARE Decimal_Cero	DECIMAL(14,2);		-- Decimal cero
    DECLARE Lis_ActArre		INT(11);			-- Tipo de lista


    -- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';				-- Valor de cadena vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Valor de fecha vacia.
	SET	Entero_Cero				:= 0;				-- Valor de entero cero.
	SET	Decimal_Cero			:= 0.0;				-- Valor de decimal cero.
    SET Lis_ActArre				:= 1;				-- Tipo de lista de activos que estan ligados a un arrendamiento

    -- Asignacion de valores nulos
    SET Par_ArrendaID  			:= IFNULL(Par_ArrendaID,Entero_Cero);

    -- Lista 1
    IF(Par_NumLis = Lis_ActArre )THEN
		SELECT	act.ActivoID,		act.Descripcion AS ActivoDescripcion,   sub.Descripcion AS SubtipoDescripcion,      mar.Descripcion AS MarcaDescripcion,        act.Modelo,
				act.NumeroSerie,	act.NumeroFactura,  					act.ValorFactura,   						act.FechaAdquisicion,   					act.PlazoMaximo,
				act.PorcentResidMax,
			CASE act.TipoActivo
				WHEN 1 THEN "AUTOS"
				WHEN 2 THEN "MUEBLES"
			END AS TipoActivo

		FROM ARRACTIVOARRENDAMIE AS actarr
        INNER JOIN ARRACTIVOS AS act ON actarr.ActivoID = act.ActivoID
        INNER JOIN ARRCSUBTIPOACTIVO AS sub ON act.SubTipoActivoID = sub.SubTipoActivoID
        INNER JOIN ARRMARCAACTIVO AS mar ON act.MarcaID = mar.MarcaID
        WHERE actarr.ArrendaID = Par_ArrendaID
        ORDER BY actarr.ArrendaID;
    END IF;



END TerminaStore$$