-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCTASASINTLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATDCTASASINTLIS`;DELIMITER $$

CREATE PROCEDURE `EDOCTATDCTASASINTLIS`(
-- Storer PROCEDURE que realiza colsulta al estado de cuentas de tazas de intereses de la targeta del credito.
	Par_Periodo				INT		(11),       -- Periodo de inicio a fecha de corte de una targeta de credito
	Par_DiaCorte			INT		(11),       -- Dia del corte del un tarjeta de credito
    Par_LineaTarCredID      INT     (11),       -- Identificador de la tarjeta de credito
    Par_NumLis				TINYINT UNSIGNED,	-- Numero de lista
    
    Aud_EmpresaID			INT,                -- Parametro de Auditoria
	Aud_Usuario				INT,                -- Parametro de Auditoria
	Aud_FechaActual			DATETIME,           -- Parametro de Auditoriae
	Aud_DireccionIP			VARCHAR	(15),       -- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR	(50),       -- Parametro de Auditoria
	Aud_Sucursal			INT,                -- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT	(20)        -- Parametro de Auditoria
  
)
TerminaStore: BEGIN
    -- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);	        -- Cadena Vacia
	DECLARE	Fecha_Vacia		DATE;		        -- Fecha Vacia
	DECLARE	Entero_Cero		INT;		        -- Entero Cero
    DECLARE Lis_Principal	INT;		        -- Lista Principal

    -- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';			        -- Entero cero
	SET Fecha_Vacia		:= '1900-01-01';        -- Asignacion de fecha vacia
	SET Entero_Cero		:= 0;			        -- Entero_Cero
    SET Lis_Principal	:= 1;			        -- Lista principal

	IF(Par_NumLis = Lis_Principal) THEN 
		SELECT Concepto,	ValorAnual,    ValorMensual,	Resaltado,	ValorDefault
			FROM    EDOCTATDCTASASINT
				WHERE Periodo  				=  Par_Periodo
					AND DiaCorte 			=  Par_DiaCorte
					AND LineaTarCredID      =  Par_LineaTarCredID
					ORDER BY ORden	;
	END IF;
END TerminaStore$$