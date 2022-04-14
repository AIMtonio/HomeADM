-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARJETACREDITOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARJETACREDITOLIS`;DELIMITER $$

CREATE PROCEDURE `TARJETACREDITOLIS`(
-- SP PARA LISTAR LAS TARJETAS DE CREDITO
    Par_TarjetaCredID        CHAR(16),			-- ID de la tarjeta
    Par_TipoTarjetaCredID    INT(11), 			-- Tipo de tarjeta
    Par_LineaTarCredID       BIGINT(12),  		-- Linea de credito
    Par_ClienteID			 INT(11),			-- Cliente
    Par_NumLis               TINYINT UNSIGNED,  -- Numero de lista

    Par_EmpresaID            INT(11),			-- Auditoria
    Aud_Usuario              INT(11),			-- Auditoria
    Aud_FechaActual          DATETIME,			-- Auditoria
    Aud_DireccionIP          VARCHAR(15),		-- Auditoria
    Aud_ProgramaID           VARCHAR(50),		-- Auditoria
    Aud_Sucursal             INT(11),			-- Auditoria
    Aud_NumTransaccion       BIGINT(20)			-- Auditoria
)
TerminaStore:BEGIN

-- Declaracion de Constantes
DECLARE Entero_Cero     	 INT(11);
DECLARE Cadena_Vacia	  	 CHAR(1);
DECLARE Est_Activado    	 INT(11);
DECLARE Est_Bloqueada   	 INT(11);
DECLARE Est_Asigna      	 INT(11);
DECLARE Est_Cancel     		 INT(11);
DECLARE Est_Expirada		 INT(11);
DECLARE IdentSocio	         CHAR(1);

DECLARE Lis_TarjetaCred      INT(11);
DECLARE Lis_TarjetaCreBloq   INT(11);
DECLARE Lis_TarCancel        INT(11);
DECLARE Lis_TarCredAsigna	 INT(11);
DECLARE Lis_TarCredGirosIndiv INT(11);
DECLARE Lis_TarCred			 INT(11);
DECLARE Lis_TarCredMov		 INT(11);
DECLARE Lis_TarjetaDebID	 INT(11);
DECLARE TipoCred			 VARCHAR(8);
DECLARE Lis_TarDebGirosIndiv INT(11);
DECLARE Lis_TarCredEst		 INT(11);
DECLARE Lis_TarCredCta		 INT(11);

-- Asiganacion de Constantes
SET Entero_Cero     		:= 0;   -- entero en cerp
SET Cadena_Vacia    		:= '';  -- cadena vacia
SET TipoCred				:='CREDITO';
SET IdentSocio              := 'S';   -- Indica que el tipo de tarjeta es de identificacion de socio

SET Est_Activado            := 7;   -- Estatus de Tarjeta Activada, tabla ESTATUSTD
SET Lis_TarjetaCred       	:= 1;   -- lista de tarjeta credito activa.
SET Lis_TarjetaCreBloq   	:= 2;   -- lISTA DE TARJETAS DE CREDITO BLOQUEADAS
SET Lis_TarCancel           := 4;
SET Lis_TarjetaDebID		:= 5;	-- actualizacion para asociar un tipo de tarjeta de un cliente
SET Est_Bloqueada           := 8;   -- Estatus Bloqueada, tabla ESTATUSTD
SET Lis_TarCredAsigna     	:= 3;   -- Lista qe muestra todas las Tarjetas con estatus Asignada a Cliente
SET Est_Asigna      		:= 6;   -- Estatus de Tarjeta Asiganda a Clientes, tabla ESTATUSTD
SET Est_Cancel     			:= 9;   -- Estatus Cancelada, tabla ESTATUSTD
SET Est_Expirada   			:= 10;  -- Estatus de Tarjeta Expirada, tabla ESTATUSTD
SET Lis_TarCredGirosIndiv   := 11;  -- Lista de Tarjetas de  Credito Activas
SET Lis_TarCred				:= 12;  -- Lista de todas las tarjetas de credito
SET Lis_TarCredMov			:= 13;	-- Lista de movimientos
SET Lis_TarCredEst			:= 14;	-- Lista por estatatus cancelado
SET Lis_TarCredCta			:= 15;	--  Lista de tarjetas asociadas al cliente
SET Aud_FechaActual 		:= NOW();


-- Muestra una lista de tarjetas de credito  activa y el nombre del cliente
IF(Par_NumLis = Lis_TarjetaCred) THEN
	SELECT Tar.TarjetaCredID, Cli.NombreCompleto
		FROM TARJETACREDITO AS Tar
		INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID AND Tar.Estatus = Est_Activado
		WHERE Tar.TarjetaCredID LIKE CONCAT('%',Par_TarjetaCredID,'%') OR
			  Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaCredID,'%')
	LIMIT 0, 15;
END IF;

-- Muestra una lista de tarjetas de debito bloqueadas y el nombre del cliente
IF(Par_NumLis = Lis_TarjetaCreBloq) THEN
	SELECT Tar.TarjetaCredID, Cli.NombreCompleto
		FROM TARJETACREDITO Tar
		INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID AND Tar.Estatus = Est_Bloqueada
		WHERE Tar.TarjetaCredID LIKE CONCAT('%',Par_TarjetaCredID,'%') OR
		Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaCredID,'%')
	LIMIT 0, 15;
END IF;

IF(Par_NumLis = Lis_TarCredAsigna) THEN
	SELECT Tar.TarjetaCredID, Cli.NombreCompleto, TipoCred AS TipoTarjeta
		FROM TARJETACREDITO Tar
		INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
		WHERE Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaCredID,'%')
			AND Tar.Estatus = Est_Asigna
	LIMIT 0, 15;
END IF;


 -- Muestra la lista de tarjeta de debito para cancelar
IF(Par_NumLis = Lis_TarCancel) THEN
	SELECT Tar.TarjetaCredID, Cli.NombreCompleto
		FROM TARJETACREDITO Tar
		LEFT JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
		WHERE Tar.Estatus != Est_Cancel AND Tar.Estatus != Est_Expirada AND Cli.ClienteID  != 0
			AND (Tar.TarjetaCredID LIKE CONCAT('%',Par_TarjetaCredID,'%') OR Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaCredID,'%'))
	LIMIT 0, 15;
END IF;



     -- 11 Muestra una lista de tarjetas de credito con estatus activa y asignada a clientes
IF(Par_NumLis = Lis_TarCredGirosIndiv) THEN
	SELECT Tar.TarjetaCredID, Cli.NombreCompleto
		FROM TARJETACREDITO Tar
		LEFT JOIN  CLIENTES  	  AS Cli ON Tar.ClienteID = Cli.ClienteID
		INNER JOIN ESTATUSTD 	  AS Est ON Est.EstatusID= Tar.Estatus  AND Tar.Estatus=Est_Activado
		INNER JOIN TIPOTARJETADEB AS Tip ON Tip.TipoTarjetaDebID = Tar.TipoTarjetaCredID	AND Tip.IdentificacionSocio != IdentSocio
		WHERE Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaCredID,'%')
			OR Tar.TarjetaCredID LIKE CONCAT('%',Par_TarjetaCredID,'%')
	LIMIT 0, 15;
END IF;

/* Muestra lista de todas las tarjetas existentes*/
IF ( Par_NumLis = Lis_TarCred ) THEN
	SELECT Tar.TarjetaCredID, Cli.NombreCompleto
		FROM TARJETACREDITO Tar
		LEFT JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
		WHERE Tar.TarjetaCredID LIKE CONCAT('%',Par_TarjetaCredID,'%')
			OR Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaCredID,'%')
	LIMIT 0, 15;
END IF;

/* Muestra la lista de tarjetas para la consulta de movimientos */
IF(Par_NumLis = Lis_TarCredMov) THEN
	SELECT Tar.TarjetaCredID, Cli.NombreCompleto
		FROM TARJETACREDITO AS Tar
		INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID AND Tar.Estatus IN (Est_Activado, Est_Bloqueada, Est_Cancel, Est_Expirada)
			INNER JOIN TIPOTARJETADEB Tip
		ON Tip.TipoTarjetaDebID = Tar.TipoTarjetaCredID
			AND Tip.IdentificacionSocio != IdentSocio
		WHERE Tar.TarjetaCredID LIKE CONCAT('%',Par_TarjetaCredID,'%') OR
		Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaCredID,'%')
	ORDER BY Tar.TarjetaCredID
	LIMIT 0, 15;
END IF;

 IF(Par_NumLis = Lis_TarjetaDebID) THEN
	SELECT Tar.TarjetaCredID, Cli.NombreCompleto
		FROM TARJETACREDITO Tar
		INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
		INNER JOIN TIPOTARJETADEB Tip
		ON Tip.TipoTarjetaDebID = Tar.TipoTarjetaCredID
			AND Tip.IdentificacionSocio != IdentSocio
			WHERE Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaCredID,'%')
	LIMIT 0, 15;
END IF;

-- Muestra una lista de Tarjetas Canceladas
IF(Par_NumLis = Lis_TarCredEst) THEN
	SELECT Tar.TarjetaCredID, Cli.NombreCompleto
		FROM TARJETACREDITO Tar
		INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
		INNER JOIN TIPOTARJETADEB Tip
		ON Tip.TipoTarjetaDebID = Tar.TipoTarjetaCredID
			AND Tip.IdentificacionSocio != IdentSocio
		WHERE Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaCredID,'%')
			AND Tar.Estatus = Est_Cancel
	LIMIT 0, 15;
END IF;


IF ( Par_NumLis = Lis_TarCredCta ) THEN
		SELECT Tar.NombreTarjeta, CASE Tar.Relacion WHEN 'T' THEN 'TITULAR'
													WHEN 'A' THEN 'ADICIONAL'
									END AS Relacion ,
			   Est.Descripcion Estatus,
               TipoCred AS TipoTarjeta
			FROM TARJETACREDITO Tar
			INNER JOIN ESTATUSTD Est ON Est.EstatusID=Tar.Estatus
			WHERE  Tar.ClienteID=Par_ClienteID;

	END IF;



END TerminaStore$$