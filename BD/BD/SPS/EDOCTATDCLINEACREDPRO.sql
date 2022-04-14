-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCLINEACREDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATDCLINEACREDPRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTATDCLINEACREDPRO`(
	Par_DiaCorte 				    INT,            -- Dia del corte del un tarjeta
	Par_Periodo     			    INT,            -- Periodo de inicio a fecha de corte de una tarjeta
	Par_FecIniCorte   			    DATE,			-- Fecha inicio corte
	Par_FecFinCorte  			    DATE,           -- Fecha fin corte

	Par_EmpresaID				    INT,			-- Parametro de Auditoria
	Aud_Usuario					    INT,			-- Parametro de Auditoria
	Aud_FechaActual				    DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP				    VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID				    VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal				    INT,			-- Parametro de Auditoria
	Aud_NumTransaccion			    BIGINT			-- Parametro de Auditoria
)
TerminaStore: BEGIN

    DECLARE	Entero_Cero				INT;
    DECLARE	Cadena_Vacia			CHAR(1);
    DECLARE	Fecha_Vacia				DATE;


    SET	Entero_Cero					:= 0;
    SET Cadena_Vacia				:= '';
    SET	Fecha_Vacia					:= '1900-01-01';


    INSERT INTO EDOCTATDCLINEACRED
    SELECT Par_Periodo,						Par_DiaCorte,						LineaTarCredID,					Entero_Cero AS ClienteID,			Entero_Cero AS TipoTarjetaDeb,
            Cadena_Vacia AS DescripcionProd, 	Cadena_Vacia AS NumTarjeta,			NOW() AS FechaGenera,			FechaCorte,							CONCAT( 'Del ', FNFECHATEXTO(FechaInicio) , ' Al ', FNFECHATEXTO(FechaCorte) ) AS PeriodoFechas,
            DiasPeriodo,						Fecha_Vacia	AS ProximoCorte, 		FechaExigible, 					Entero_Cero AS CuentaClabe,			MesesPagMin,
            PagoDoceMeses,    Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
    FROM TC_PERIODOSLINEA
    WHERE FechaCorte = Par_FecFinCorte;


    UPDATE EDOCTATDCLINEACRED Edc
        INNER JOIN LINEATARJETACRED Lin ON Edc.LineaTarCredID = Lin.LineaTarCredID
    SET	Edc.ClienteID = Lin.ClienteID,
            Edc.TipoTarjetaDebID = Lin.TipoTarjetaDeb,
            Edc.FechaProxCorte	= Lin.FechaProxCorte,
            Edc.NumTarjeta	= Lin.TarjetaPrincipal,
            Edc.CuentaClabe = Lin.CuentaClabe;

    UPDATE EDOCTATDCLINEACRED Edc
        INNER JOIN TIPOTARJETADEB Prod ON Edc.TipoTarjetaDebID = Prod.TipoTarjetaDebID
    SET	Edc.DescripcionProd = Prod.Descripcion;

END TerminaStore$$