-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_BITACORAMOVSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_BITACORAMOVSLIS`;
DELIMITER $$


CREATE PROCEDURE `TC_BITACORAMOVSLIS`(
#SP PARA LISTAR LOS MOVIMIENTOS DE LA TARJETA DE CREDITO
	Par_TarjetaCredID		CHAR(16),			-- Parametro de Tarjeta Credito ID
    Par_AnioPeriodo			INT,				-- Parametro Anio Periodo
    Par_MesPeriodo			INT,				-- Parametro Mes Periodo
    Par_NumLis         		TINYINT UNSIGNED,	-- Parametro numero lista

    Par_EmpresaID       	INT,				-- Parametro de Auditoria
    Aud_Usuario         	INT,				-- Parametro de Auditoria
    Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal        	INT,				-- Parametro de Auditoria
    Aud_NumTransaccion  	BIGINT				-- Parametro de Auditoria
	)

TerminaStore: BEGIN

DECLARE Cadena_Vacia    	CHAR(1);			-- cadena vacia
DECLARE Entero_Cero     	INT;				-- entero cero
DECLARE Decimal_Cero		DECIMAL(12,2);		-- DECIMAL cero
DECLARE Est_Procesado    	CHAR(1);			-- estatus procesado
DECLARE Lis_Principal		INT;				-- lista principal
DECLARE Nat_Cargo			CHAR(1);			-- naturalidad cargo
DECLARE Nat_Abono			CHAR(1);			-- naturalidad abono
DECLARE MonedaMX			INT;				-- moneda Mx
DECLARE MonedaUSD			INT;				-- moneda USD

SET Entero_Cero     	:= 0;
SET Decimal_Cero		:= '0.00';
SET Cadena_Vacia    	:= '';
SET Est_Procesado       := 'P';
SET Lis_Principal   	:= 1;
SET Nat_Cargo			:= 'C';
SET Nat_Abono			:= 'A';
SET MonedaMX			:= 484;
SET MonedaUSD			:= 840;


    IF(Par_NumLis = Lis_Principal) THEN
		SELECT
			FechaOperacion, Referencia, CONCAT(NombreComercio,' [',Ciudad,', ',Pais,']', CASE WHEN CodigoMonOpe = MonedaUSD THEN CONCAT(' / Dolar $ ',MontoOperacion,', TC: $ ',TipoCambio) ELSE '' END ) AS NombreComercio,
            CASE WHEN Naturaleza = Nat_Cargo THEN (MontoOperacionMx + MontoCashBackMx + MontoComisionMx + MontoIvaMx + MontoAdicionalMx) ELSE Entero_Cero END AS Cargos,
			CASE WHEN Naturaleza = Nat_Abono THEN (MontoOperacionMx + MontoCashBackMx + MontoComisionMx + MontoIvaMx + MontoAdicionalMx) ELSE Entero_Cero END AS Abonos
		FROM  TC_BITACORAMOVS
		WHERE TarjetaCredID = Par_TarjetaCredID AND Estatus = Est_Procesado
		  AND YEAR(FechaOperacion) = Par_AnioPeriodo AND MONTH(FechaOperacion) = Par_MesPeriodo;

	END IF;


END TerminaStore$$
