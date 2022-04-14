-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARCREDGIROSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARCREDGIROSLIS`;DELIMITER $$

CREATE PROCEDURE `TARCREDGIROSLIS`(
-- SP PARA LISTAR LOS GIROS DE LA TARJETA DE CREDITO
    Par_TarjetaCredID       CHAR(16),				-- ID de la tarjeta de credito
    Par_NumLis              TINYINT  UNSIGNED,		-- Numero de lista

    Par_EmpresaID           INT(11),				-- Auditoria
    Aud_Usuario             INT(11), 				-- Auditoria
    Aud_FechaActual         DATETIME,				-- Auditoria
    Aud_DireccionIP         VARCHAR(15),			-- Auditoria
    Aud_ProgramaID          VARCHAR(50),			-- Auditoria
    Aud_Sucursal            INT(11),				-- Auditoria
    Aud_NumTransaccion      BIGINT(20)				-- Auditoria
	)
TerminaStore:BEGIN

-- Declaracion de Constantes
DECLARE listaGirosTarIndiv	INT;
DECLARE Entero_Cero		    INT;
DECLARE Cadena_Vacia	    CHAR(1);
DECLARE Est_Activado    	CHAR(1);

-- Asiganacion de Constantes
SET Entero_Cero		    := 0;	   -- entero en cero
SET Cadena_Vacia		:= '';	   -- cadena vacia
SET Est_Activado    	:= 'A';    -- Estatus de Tarjeta Activada, tabla TARDEBGIROSNEGISO
SET listaGirosTarIndiv	:= 2; 	   -- Lista de giros aceptados por tarjeta individual


/* 2. Muestra lista de giros aceptados por tarjeta individual */
IF(Par_NumLis=listaGirosTarIndiv)THEN
	SELECT T.TarjetaCredID,Tar.GiroID,Tar.Descripcion
		FROM TARDEBGIROSNEGISO  Tar
	INNER JOIN TARCREDGIROS T ON T.GiroID=Tar.GiroID
		WHERE T.TarjetaCredID=Par_TarjetaCredID
		AND Tar.Estatus=Est_Activado;
END IF;

END TerminaStore$$