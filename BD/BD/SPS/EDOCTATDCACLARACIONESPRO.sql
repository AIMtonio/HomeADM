-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCACLARACIONESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATDCACLARACIONESPRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTATDCACLARACIONESPRO`(
	Par_DiaCorte 		INT,			-- Dia del corte del un tarjeta
	Par_Periodo     	INT,			-- Periodo de inicio a fecha de corte de una tarjeta
	Par_FecIniCorte   	DATE,			-- Fecha inicio corte
	Par_FecFinCorte  	DATE,			-- Fecha fin corte

	Par_EmpresaID		INT,			-- Parametro de Auditoria
	Aud_Usuario			INT,			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal		INT,			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT			-- Parametro de Auditoria
)
TerminaStore: BEGIN

    DECLARE	Entero_Cero					INT;
    DECLARE	Cadena_Vacia				CHAR(1);
    DECLARE	Fecha_Vacia					DATE;

    SET	Entero_Cero					:= 0;
    SET Cadena_Vacia				:= '';
    SET	Fecha_Vacia					:= '1900-01-01';


    -- Se insertan las declaraciones de tipo de tarjera C con estatus A y S
	INSERT INTO EDOCTATDCACLARACIONES
	SELECT 	Par_Periodo,							Par_DiaCorte,								CL.LineaTarCredID,						CO.TarjetaDebID,						CO.FechaOperacion AS Fecha,
			CO.DetalleReporte AS Descripcion,		CO.TransaccionRep AS FolioAclaracion, 		CO.FechaAclaracion AS FechaApertura,	CO.MontoOperacion AS Importe,
			Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
	FROM TARDEBACLARACION CO
	INNER JOIN TARJETACREDITO TC
	   ON CO.TarjetaDebID = TC.TarjetaCredID AND CO.TipoTarjeta = 'C'
	INNER JOIN EDOCTATDCLINEACRED CL
	   ON CL.LineaTarCredID = TC.LineaTarCredID
	WHERE CO.Estatus IN ('A','S');

    -- Se insertan los registros de tipo de tarjera C con estatus R y que su FechaAclaracion se encuentre entre la fecha inicio y fin de la fecha corte
	INSERT INTO EDOCTATDCACLARACIONES
	SELECT 	Par_Periodo,							Par_DiaCorte,								CL.LineaTarCredID,						CO.TarjetaDebID,						CO.FechaOperacion AS Fecha,
			CO.DetalleReporte AS Descripcion,		CO.TransaccionRep AS FolioAclaracion, 		CO.FechaAclaracion AS FechaApertura,	CO.MontoOperacion AS Importe,
			Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
	FROM TARDEBACLARACION CO
	INNER JOIN TARJETACREDITO TC
	   ON CO.TarjetaDebID = TC.TarjetaCredID AND CO.TipoTarjeta = 'C'
	INNER JOIN EDOCTATDCLINEACRED CL
	   ON CL.LineaTarCredID = TC.LineaTarCredID
	WHERE CO.Estatus = 'R'
	   AND CO.FechaAclaracion >= Par_FecIniCorte
       AND CO.FechaAclaracion <= Par_FecFinCorte;


END TerminaStore$$