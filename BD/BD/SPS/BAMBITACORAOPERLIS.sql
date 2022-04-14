-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMBITACORAOPERLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMBITACORAOPERLIS`;DELIMITER $$

CREATE PROCEDURE `BAMBITACORAOPERLIS`(
	-- SP que lista las operaciones de un cliente en la banca movil
	Par_ClienteID			BIGINT(20),			-- ID del cliente a consultar
	Par_TipoOperID			BIGINT(20),			-- Tipo de operacion
	Par_FechaInicio			DATE,				-- Fecha de inicio
	Par_FechaFin			DATE,				-- Fecha final
    Par_NumLis         		TINYINT UNSIGNED,	-- Numero de listas

    Par_EmpresaID       	INT,				-- Auditoria
    Aud_Usuario         	INT,				-- Auditoria
    Aud_FechaActual     	DATETIME,			-- Auditoria
    Aud_DireccionIP     	VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      	VARCHAR(50),		-- Auditoria
    Aud_Sucursal        	INT,				-- Auditoria
    Aud_NumTransaccion  	BIGINT				-- Auditoria
)
TerminaStore: BEGIN
-- Declaracion de variables
DECLARE Lis_Principal   	INT;				-- Lista Principal
DECLARE All_Movs			INT;  				-- Todos los movimientos
DECLARE Inicio_Sesion		INT;				-- Inicio de Sesion
DECLARE Configuraciones	    INT(1);

SET Lis_Principal   		:= 1;   			-- Lista principal
SET All_Movs				:= 0; 				-- Devuelve todos los movimimientos
SET Inicio_Sesion			:= 1; 				-- Devuelve los inicio de sesion
SET Configuraciones			:= 6;				-- Devuelve movimientos de configuraciones

IF Par_NumLis = Lis_Principal THEN

	IF Par_TipoOperID = All_Movs THEN
			SELECT
				TipoOperacionID,	FechaOperacion,			Monto,						Descripcion,	Referencia,
				Folio,				DireccionIP AS IP ,		ProgramaID AS Dispositivo
			FROM BAMBITACORAOPERACIONES
			WHERE Par_ClienteID = ClienteID
				AND DATE(FechaOperacion) >= DATE(Par_FechaInicio) AND DATE(FechaOperacion) <= DATE(Par_FechaFin) ORDER BY FechaOperacion DESC;

    ELSEIF(Par_TipoOperID = Configuraciones) THEN
		SELECT
				TipoOperacionID,	FechaOperacion,			 Monto,						Descripcion,	Referencia,
				Folio,				DireccionIP AS IP ,		ProgramaID AS Dispositivo
			FROM BAMBITACORAOPERACIONES
			WHERE Par_ClienteID = ClienteID AND (Configuraciones=TipoOperacionID || (Configuraciones+1)=TipoOperacionID || (Configuraciones+2)=TipoOperacionID)
				AND DATE(FechaOperacion) >= DATE(Par_FechaInicio) AND DATE(FechaOperacion) <= DATE(Par_FechaFin) ORDER BY FechaOperacion DESC;

    ELSE
		SELECT
				TipoOperacionID,		FechaOperacion,			Monto,						Descripcion,	Referencia,
				Folio,					DireccionIP AS IP ,		ProgramaID AS Dispositivo
			FROM BAMBITACORAOPERACIONES
			WHERE Par_ClienteID = ClienteID AND Par_TipoOperID=TipoOperacionID
				AND DATE(FechaOperacion) >= DATE(Par_FechaInicio) AND DATE(FechaOperacion) <= DATE(Par_FechaFin) ORDER BY FechaOperacion DESC;
    END IF;
END IF;

END TerminaStore$$