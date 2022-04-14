-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARJETADEBITOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARJETADEBITOLIS`;
DELIMITER $$


CREATE PROCEDURE `TARJETADEBITOLIS`(
#SP PARA LISTA DE TARJETAS DE DEBITO
	Par_TarjetaDebID        CHAR(16),			-- Parametro de Tarjeta Debito ID
    Par_TipoTarjetaDebID    INT(11),			-- Parametro de Tipo Tarjeta ID
    Par_NumCuenta           BIGINT(12),			-- Parametro de numero de cuenta
    Par_NumLis              TINYINT UNSIGNED,	-- Parametro de numero de lista

    Par_EmpresaID           INT(11),			-- Parametro de Auditoria
    Aud_Usuario             INT(11),			-- Parametro de Auditoria
    Aud_FechaActual         DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP         VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID          VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal            INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion      BIGINT(20)			-- Parametro de Auditoria
)

TerminaStore:BEGIN

-- Declaracion de Constantes
DECLARE Entero_Cero     	INT(11);
DECLARE Cadena_Vacia	  	CHAR(1);
DECLARE Est_Importado	  	CHAR(1);
DECLARE Est_Activado    	INT(11);
DECLARE Est_Cancel     		INT(11);
DECLARE Est_Bloqueada   	INT(11);
DECLARE Est_Asigna      	INT(11);
DECLARE Est_Expirada    	INT(11);
DECLARE Est_Solicitada  	INT(11);
DECLARE Est_Maquilador  	INT(11);
DECLARE Est_proMaquilador 	INT(11);


-- Declaracion de  variables
DECLARE Var_Sentencia 		VARCHAR(4000);

DECLARE Lis_Principal       	INT(11);
DECLARE Lis_TarjetaDeb      	INT(11);
DECLARE Lis_TarjetaDebID    	INT(11);
DECLARE Lis_TarDebEst       	INT(11);
DECLARE Lis_TarjetaDebBloq  	INT(11);
DECLARE Lis_TarDebAsigna    	INT(11);
DECLARE Lis_TarCancel       	INT(11);
DECLARE Lis_TarjetaDebito   	INT(11);
DECLARE Lis_TarDebCteNuno		INT(11);
DECLARE Lis_LimiteTarDeb    	INT(11);
DECLARE Lis_TarDebGirosIndiv	INT(11);
DECLARE Lis_TarDebSoliEst    	INT(11);
DECLARE Lis_TarDebMov			INT(11);
DECLARE Lis_TarDebCobroAnual	INT(11);
DECLARE Lis_TarDeb				INT(11);
DECLARE Lis_TarDebCta			INT(11);
DECLARE Lis_TarDebPorCuenta     INT(11);
DECLARE IdentSocio	            CHAR(1);
DECLARE TipoDeb				VARCHAR(8);

-- Asiganacion de Constantes
SET Entero_Cero     	:= 0;   -- entero en cerp
SET Cadena_Vacia    	:= '';  -- cadena vacia
SET TipoDeb				:='DEBITO';
SET Est_Importado   	:= 1;   -- importada de lote  corresponde con tabla ESTATUSTD
SET Est_Asigna      	:= 6;   -- Estatus de Tarjeta Asiganda a Clientes, tabla ESTATUSTD
SET Est_Activado    	:= 7;   -- Estatus de Tarjeta Activada, tabla ESTATUSTD
SET Est_Bloqueada   	:= 8;   -- Estatus Bloqueada, tabla ESTATUSTD
SET Est_Cancel     		:= 9;   -- Estatus Cancelada, tabla ESTATUSTD
SET Est_Expirada    	:= 10;  -- Estatus de Tarjeta Expirada, tabla ESTATUSTD
SET Est_Solicitada  	:= 11;  -- Estatus de Tarjeta Solicitada, tabla ESTATUSTD
SET Est_Maquilador  	:=12;
SET Est_proMaquilador   :=13;

SET Lis_Principal        := 1;    -- actualizacion para asociar una tarjeta a una cuentacte
SET Lis_TarjetaDeb       := 2;    -- lista de tarjeta debito activa.
SET Lis_TarjetaDebID     := 5;    -- actualizacion para asociar un tipo de tarjeta de un cliente
SET Lis_TarDebEst        := 4;    -- filtra la lista por el numero de tarjeta y consulta por Estatus Cancelado.
SET Lis_TarjetaDebBloq   := 6;
SET Lis_TarDebAsigna     := 7;    -- Lista qe muestra todas las Tarjetas con estatus Asignada a Cliente
SET Lis_TarCancel        := 8;
SET Lis_TarjetaDebito    := 9;
SET Lis_LimiteTarDeb     := 10;
SET Lis_TarDebGirosIndiv := 11;   -- Lista de Tarjetas de Debito Activas
SET Lis_TarDebSoliEst    := 12;   -- Lista de Tarjetas de Debito Cancelada
SET Lis_TarDebMov        := 13;   -- Lista de Tarjetas para la consulta de Movimientos
SET Lis_TarDebCobroAnual := 14;	  -- Lista usada en  El cobro de Anualidad de tarjeta de Debito
SET Lis_TarDeb			 := 15;	  -- Lista de todas las Tarjetas existentes
SET Lis_TarDebCta		 := 16;	  -- Lista todas las tarjetas relacionadas a la cuenta indicada
SET Lis_TarDebPorCuenta  := 17;   -- lista tarjetas asociadas a una cuenta
SET IdentSocio          := 'S';   -- Indica que el tipo de tarjeta es de identificacion de socio

SET Aud_FechaActual := NOW();

    /* Muestra una lista las tarjetas de debito fitrando por lo que el usuario envio*/
    IF(Par_NumLis = Lis_Principal) THEN
        SELECT TarjetaDebID
            FROM TARJETADEBITO
            WHERE TarjetaDebID LIKE CONCAT("%", Par_TarjetaDebID, "%")
                AND CuentaAhoID = IFNULL(Par_NumCuenta,Entero_Cero)
                AND TipoTarjetaDebID = Par_TipoTarjetaDebID
            LIMIT 0, 15;
    END IF;

    -- Muestra una lista de tarjetas de debito  activa y el nombre del cliente
    IF(Par_NumLis = Lis_TarjetaDeb) THEN
        SELECT Tar.TarjetaDebID, Cli.NombreCompleto
            FROM TARJETADEBITO AS Tar
            INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID AND Tar.Estatus = Est_Activado
            WHERE Tar.TarjetaDebID LIKE CONCAT('%',Par_TarjetaDebID,'%') OR
            Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaDebID,'%')
        LIMIT 0, 15;
    END IF;

    -- Muestra una lista de tarjetas de debito y el nombre del cliente
    IF(Par_NumLis = Lis_TarjetaDebID) THEN
        SELECT Tar.TarjetaDebID, Cli.NombreCompleto
            FROM TARJETADEBITO Tar
            INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
			INNER JOIN TIPOTARJETADEB Tip
			ON Tip.TipoTarjetaDebID = Tar.TipoTarjetaDebID
				AND Tip.IdentificacionSocio != IdentSocio
                WHERE Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaDebID,'%')
        LIMIT 0, 15;
    END IF;

    -- Muestra una lista de Tarjetas Canceladas
    IF(Par_NumLis = Lis_TarDebEst) THEN
        SELECT Tar.TarjetaDebID, Cli.NombreCompleto
            FROM TARJETADEBITO Tar
            INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
			INNER JOIN TIPOTARJETADEB Tip
			ON Tip.TipoTarjetaDebID = Tar.TipoTarjetaDebID
				AND Tip.IdentificacionSocio != IdentSocio
            WHERE Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaDebID,'%')
                AND Tar.Estatus = Est_Cancel
        LIMIT 0, 15;
    END IF;

    -- Muestra una lista de tarjetas de debito bloqueadas y el nombre del cliente
    IF(Par_NumLis = Lis_TarjetaDebBloq) THEN
        SELECT Tar.TarjetaDebID, Cli.NombreCompleto
            FROM TARJETADEBITO Tar
            INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID AND Tar.Estatus = Est_Bloqueada
            WHERE Tar.TarjetaDebID LIKE CONCAT('%',Par_TarjetaDebID,'%') OR
            Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaDebID,'%')
        LIMIT 0, 15;
    END IF;

    -- Muestra una lista de tarjetas de debito con estatus asignada a clientes
    IF(Par_NumLis = Lis_TarDebAsigna) THEN
        SELECT Tar.TarjetaDebID, Cli.NombreCompleto, TipoDeb AS TipoTarjeta
            FROM TARJETADEBITO Tar
            INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
            WHERE Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaDebID,'%')
                AND Tar.Estatus = Est_Asigna
        LIMIT 0, 15;
    END IF;

    -- Muestra la lista de tarjeta de debito para cancelar
    IF(Par_NumLis = Lis_TarCancel) THEN
		SELECT Tar.TarjetaDebID, Cli.NombreCompleto
            FROM TARJETADEBITO Tar
            LEFT JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
            WHERE Tar.Estatus != Est_Cancel AND Tar.Estatus != Est_Expirada AND Cli.ClienteID  != 0
				AND (Tar.TarjetaDebID LIKE CONCAT('%',Par_TarjetaDebID,'%') OR Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaDebID,'%'))
        LIMIT 0, 15;
    END IF;

    IF(Par_NumLis = Lis_TarjetaDebito) THEN
        SELECT Tar.TarjetaDebID, Cli.NombreCompleto
            FROM TARJETADEBITO Tar
            INNER JOIN CLIENTES AS Cli ON Tar.ClienteID = Cli.ClienteID
            WHERE Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaDebID,'%')
				OR Tar.TarjetaDebID LIKE CONCAT('%',Par_TarjetaDebID,'%')
        LIMIT 0, 15;
    END IF;
 IF(Par_NumLis = Lis_LimiteTarDeb) THEN
        SELECT Tar.TarjetaDebID, Cli.NombreCompleto
            FROM TARJETADEBITO Tar
            LEFT JOIN CLIENTES AS Cli ON Tar.ClienteID = Cli.ClienteID
            INNER JOIN ESTATUSTD AS Est ON Est.EstatusID= Tar.Estatus
            WHERE Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaDebID,'%')
                OR Tar.TarjetaDebID LIKE CONCAT('%',Par_TarjetaDebID,'%') AND Tar.Estatus=Est_Activado
        LIMIT 0, 15;
    END IF;
 -- 11 Muestra una lista de tarjetas de debito con estatus activa y asignada a clientes
IF(Par_NumLis = Lis_TarDebGirosIndiv) THEN
        SELECT Tar.TarjetaDebID, Cli.NombreCompleto
            FROM TARJETADEBITO Tar
            LEFT JOIN CLIENTES 		  AS Cli ON Tar.ClienteID = Cli.ClienteID
            INNER JOIN ESTATUSTD 	  AS Est ON Est.EstatusID= Tar.Estatus  AND Tar.Estatus=Est_Activado
			INNER JOIN TIPOTARJETADEB AS Tip	ON Tip.TipoTarjetaDebID = Tar.TipoTarjetaDebID	AND Tip.IdentificacionSocio != IdentSocio
            WHERE Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaDebID,'%')
                OR Tar.TarjetaDebID LIKE CONCAT('%',Par_TarjetaDebID,'%')
        LIMIT 0, 15;
    END IF;

 /* 12 Muestra una lista las tarjetas de debito filtrando por su estatus*/
    IF(Par_NumLis = Lis_TarDebSoliEst) THEN
         SELECT Descripcion
            FROM ESTATUSTD
            WHERE EstatusID=Est_Cancel;
    END IF;

/* Muestra la lista de tarjetas para la consulta de movimientos */
	IF(Par_NumLis = Lis_TarDebMov) THEN
		SELECT Tar.TarjetaDebID, Cli.NombreCompleto
            FROM TARJETADEBITO AS Tar
            INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID AND Tar.Estatus IN (Est_Activado, Est_Bloqueada, Est_Cancel, Est_Expirada)
				INNER JOIN TIPOTARJETADEB Tip 	ON Tip.TipoTarjetaDebID = Tar.TipoTarjetaDebID 	AND Tip.IdentificacionSocio != IdentSocio
            WHERE Tar.TarjetaDebID LIKE CONCAT('%',Par_TarjetaDebID,'%') OR  Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaDebID,'%')
		ORDER BY Tar.TarjetaDebID
        LIMIT 0, 15;
	END IF;


/* Muestra la lista de tarjetas para la consulta de movimientos */
	IF(Par_NumLis = Lis_TarDebCobroAnual) THEN
		SELECT Tar.TarjetaDebID, Cli.NombreCompleto
            FROM TARJETADEBITO AS Tar
            INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
			INNER JOIN TIPOTARJETADEB TTD ON TTD.TipoTarjetaDebID=Tar.TipoTarjetaDebID AND TTD.IdentificacionSocio!="S"
			AND Tar.Estatus IN (Est_Activado, Est_Bloqueada)
            WHERE Tar.TarjetaDebID LIKE CONCAT('%',Par_TarjetaDebID,'%') OR
            Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaDebID,'%')
       LIMIT 0, 15;
	END IF;

	/* Muestra lista de todas las tarjetas existentes*/
	IF ( Par_NumLis = Lis_TarDeb ) THEN
		SELECT Tar.TarjetaDebID, Cli.NombreCompleto
            FROM TARJETADEBITO Tar
            LEFT JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
            WHERE Tar.TarjetaDebID LIKE CONCAT('%',Par_TarjetaDebID,'%')
                OR Cli.NombreCompleto LIKE CONCAT('%',Par_TarjetaDebID,'%')
        LIMIT 0, 15;
	END IF;

	IF ( Par_NumLis = Lis_TarDebCta ) THEN
		SELECT Tar.NombreTarjeta, CASE Tar.Relacion WHEN 'T' THEN 'TITULAR'
													WHEN 'A' THEN 'ADICIONAL' END AS Estatus ,
			   Est.Descripcion,Tip.Descripcion AS TipoTarjeta
		  FROM TARJETADEBITO Tar
		 INNER JOIN ESTATUSTD Est ON EstatusID=Tar.Estatus
		 INNER JOIN TIPOTARJETADEB Tip ON Tip.TipoTarjetaDebID=Tar.TipoTarjetaDebID
		 WHERE CuentaAhoID = Par_NumCuenta;
	END IF;

    	/* Muestra lista de todas las tarjetas existentes*/
	IF ( Par_NumLis = Lis_TarDebPorCuenta ) THEN
    	SET Var_Sentencia := CONCAT('
		SELECT Tar.TarjetaDebID,Cli.NombreCompleto
            FROM TARJETADEBITO Tar
            LEFT JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
            INNER JOIN CUENTASAHO Cue ON Cue.CuentaAhoID=Tar.CuentaAhoID
            WHERE (Tar.TarjetaDebID LIKE CONCAT("%",');
            SET Var_Sentencia := CONCAT(Var_Sentencia,'"',Par_TarjetaDebID,'"');
			SET Var_Sentencia := CONCAT(Var_Sentencia,',"%") OR ');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' Cli.NombreCompleto  LIKE CONCAT("%",');
            SET Var_Sentencia := CONCAT(Var_Sentencia,'"', Par_TarjetaDebID,'"');
            SET Var_Sentencia := CONCAT(Var_Sentencia,',"%")) ');


        IF(Par_NumCuenta != Entero_Cero)THEN
            SET Var_Sentencia := CONCAT(Var_sentencia,' AND	Cue.CuentaAhoID	= ', Par_NumCuenta);
        END IF;

        SET Var_Sentencia	:=	CONCAT(Var_sentencia,' LIMIT 0, 15 ; ');
        SET @Sentencia   	:=	(Var_Sentencia);
        PREPARE TARJETASDEB FROM @Sentencia;
		EXECUTE TARJETASDEB;
		DEALLOCATE PREPARE TARJETASDEB;

	END IF;
END TerminaStore$$