-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCLINEACREDLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATDCLINEACREDLIS`;DELIMITER $$

CREATE PROCEDURE `EDOCTATDCLINEACREDLIS`(
    -- Storer PROCEDURE que realizar consulta a la linea de targeta de credito de un cliente
	Par_Periodo			         INT		(11),            -- Periodo de inicio a fecha de corte de una targeta de credito
	Par_DiaCorte		         INT		(11),            -- Dia del corte del un tarjeta de credito
	Par_Linea			         BIGINT	(20),                -- Linea del credito 
    Par_NumLis			         TINYINT UNSIGNED,	         -- Numero de lista
    
    Aud_EmpresaID		         INT,                        -- Parametro de Auditoria
	Aud_Usuario			         INT,                        -- Parametro de Auditoria
	Aud_FechaActual		         DATETIME,                   -- Parametro de Auditoria
	Aud_DireccionIP		         VARCHAR	(15),            -- Parametro de Auditoria
	Aud_ProgramaID		         VARCHAR	(50),                -- Parametro de Auditoria
	Aud_Sucursal		         INT,                        -- Parametro de Auditoria
	Aud_NumTransaccion	         BIGINT	(20)                 -- Parametro de Auditoria
  
)
TerminaStore: BEGIN
    -- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);				         -- Cadena Vacia
	DECLARE	Fecha_Vacia		DATE;					         -- Fecha Vacia
	DECLARE	Entero_Cero		INT;					         -- Entero Cero
    DECLARE Lis_Principal	TINYINT UNSIGNED;		         -- Lista Principal

    -- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';			                     -- Entero cero
	SET Fecha_Vacia		:= '1900-01-01';                     -- Asignacion de fecha vacia
	SET Entero_Cero		:= 0;			                     -- Entero_Cero
    SET Lis_Principal	:= 1;			                     -- Lista principal

	IF(Par_NumLis = Lis_Principal) THEN 
		SELECT  RIGHT(CONCAT('00000000000', CAST(Cte.ClienteID AS CHAR)) , 11)AS ClienteID,
				Cte.ClienteID,			Cte.NombreCompleto,		Cte.SucursalID,			Cte.NombreSucurs,		Cte.TipoPer,
                Cte.DescriTipoPer,		Cte.RFC,				Cte.Calle,				Cte.NumInt,				Cte.NumExt,
                Cte.Colonia,			Cte.Municip_Deleg,		Cte.Estado,				Cte.CodigoPostal,		Cte.NombreInstit,
                Cte.DireccionInstit,	Lin.LineaTarCredID,		Lin.TipoTarjetaDebID,	Lin.DescripcionProd,	Lin.NumTarjeta AS NumTarjeta,
                Lin.FechaGenera,		Lin.FechaCorte,			Lin.PeriodoFechas,		Lin.DiasPeriodo,		Lin.FechaProxCorte,
                Lin.CuentaClabe,		Lin.MesesPagMin,		Lin.PagoDoceMeses,                 
                
                CONCAT(    Cte.Calle,      
						CASE WHEN Cte.NumExt  <> '' THEN CONCAT(' ', Cte.NumExt)      ELSE '' END,
						CASE WHEN Cte.NumInt  <> '' THEN CONCAT(' INT.' , Cte.NumInt) ELSE '' END,
						CASE WHEN Cte.Colonia <> '' THEN CONCAT(' ' , Cte.Colonia)    ELSE '' END ) AS DireccionComp,
                CONCAT(SUBSTRING(Lin.NumTarjeta, 1, 4), ' ' ,SUBSTRING(Lin.NumTarjeta, 5, 4), ' ' ,SUBSTRING(Lin.NumTarjeta, 9, 4), ' ' ,SUBSTRING(Lin.NumTarjeta, 13, 4) )AS nuevoNTarj,
                FechaExigible
		 FROM			EDOCTATDCLINEACRED Lin
			INNER JOIN	EDOCTATDCDATOSCTE Cte 
				ON 		Lin.ClienteID = Cte.ClienteID
		 WHERE Lin.Periodo 			= Par_Periodo
			AND Lin.DiaCorte		= Par_DiaCorte
			AND Lin.LineaTarCredID  = Par_Linea;
	END IF;
END TerminaStore$$