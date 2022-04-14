-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIRECTIVOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIRECTIVOSLIS`;DELIMITER $$

CREATE PROCEDURE `DIRECTIVOSLIS`(
# =====================================================================================
#                   ----- STORED QUE LISTA LOS DIRECTIVOS  -----------------
# =====================================================================================

    Par_NumCliente      BIGINT(12),         # Numero de Cliente
    Par_NumGarante      BIGINT(12),
    Par_NumAval         BIGINT(12),
    Par_NombreCompleto  VARCHAR(100),       # Nombre Completo
    Par_NumLis          TINYINT UNSIGNED,   # Numero de Lista

    # Parametros de Auditoria
    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
    )
TerminaStore: BEGIN

-- DECLARACION DE CONSTANTES
DECLARE     Cadena_Vacia        CHAR(1);
DECLARE     Fecha_Vacia         DATE;
DECLARE     Entero_Cero         INT;
DECLARE     Lis_Principal       INT;

-- ASIGNACION DE CONSTANTES
SET Cadena_Vacia        := '';                      -- Constante Vacio --
SET Fecha_Vacia         := '1900-01-01';            -- Constante 1900-01-01--
SET Entero_Cero         := 0;                       -- Constante Cero--
SET Lis_Principal       := 1;                       -- Lista Principal --

# LISTA PRINCIPAL
IF(Par_NumLis = Lis_Principal AND Par_NumCliente <> Entero_Cero) THEN

    (SELECT DirectivoID,  Cli.NombreCompleto
        FROM    DIRECTIVOS Dir
        INNER JOIN CLIENTES Cli ON Dir.RelacionadoID = Cli.ClienteID
        AND (IFNULL(Cli.NombreCompleto, Cadena_Vacia) LIKE CONCAT("%", Cadena_Vacia, "%")
        OR  IFNULL(Dir.NombreCompleto, Cadena_Vacia) LIKE CONCAT("%", Cadena_Vacia, "%"))
        AND Dir.RelacionadoID <> Entero_Cero
        AND Dir.ClienteID = Par_NumCliente)
        UNION
    (SELECT DirectivoID,  Gar.NombreCompleto
        FROM    DIRECTIVOS Dir
        INNER JOIN GARANTES Gar ON Dir.GaranteRelacion = Gar.GaranteID
        AND (IFNULL(Gar.NombreCompleto, Cadena_Vacia) LIKE CONCAT("%", Cadena_Vacia, "%")
        OR  IFNULL(Dir.NombreCompleto, Cadena_Vacia) LIKE CONCAT("%", Cadena_Vacia, "%"))
        AND Dir.GaranteRelacion <> Entero_Cero
        AND Dir.ClienteID = Par_NumCliente)
        UNION
    (SELECT DirectivoID,  Ava.NombreCompleto
        FROM    DIRECTIVOS Dir
        INNER JOIN AVALES Ava ON Dir.AvalRelacion = Ava.AvalID
        AND (IFNULL(Ava.NombreCompleto, Cadena_Vacia) LIKE CONCAT("%", Cadena_Vacia, "%")
        OR  IFNULL(Dir.NombreCompleto, Cadena_Vacia) LIKE CONCAT("%", Cadena_Vacia, "%"))
        AND Dir.AvalRelacion <> Entero_Cero
        AND  Dir.ClienteID = Par_NumCliente)
        UNION
    (SELECT DirectivoID,  Dir.NombreCompleto
    FROM    DIRECTIVOS Dir
        WHERE Dir.DirectivoID <> Entero_Cero AND
        Dir.RelacionadoID = Entero_Cero AND Dir.GaranteRelacion= Entero_Cero AND Dir.AvalRelacion=Entero_Cero
        AND  Dir.ClienteID = Par_NumCliente)
    ORDER BY DirectivoID ASC
    LIMIT 0, 15;

END IF;


IF(Par_NumLis = Lis_Principal AND Par_NumGarante <> Entero_Cero) THEN

    (SELECT DirectivoID,  Cli.NombreCompleto
        FROM    DIRECTIVOS Dir
        INNER JOIN CLIENTES Cli ON Dir.RelacionadoID = Cli.ClienteID
        AND (IFNULL(Cli.NombreCompleto, Cadena_Vacia) LIKE CONCAT("%", Cadena_Vacia, "%")
        OR  IFNULL(Dir.NombreCompleto, Cadena_Vacia) LIKE CONCAT("%", Cadena_Vacia, "%"))
        AND Dir.RelacionadoID <> Entero_Cero
        AND Dir.GaranteID = Par_NumGarante)
        UNION
    (SELECT DirectivoID,  Gar.NombreCompleto
        FROM    DIRECTIVOS Dir
        INNER JOIN GARANTES Gar ON Dir.GaranteRelacion = Gar.GaranteID
        AND (IFNULL(Gar.NombreCompleto, Cadena_Vacia) LIKE CONCAT("%", Cadena_Vacia, "%")
        OR  IFNULL(Dir.NombreCompleto, Cadena_Vacia) LIKE CONCAT("%", Cadena_Vacia, "%"))
        AND Dir.GaranteRelacion <> Entero_Cero
        AND Dir.GaranteID = Par_NumGarante)
        UNION
    (SELECT DirectivoID,  Ava.NombreCompleto
        FROM    DIRECTIVOS Dir
        INNER JOIN AVALES Ava ON Dir.AvalRelacion = Ava.AvalID
        AND (IFNULL(Ava.NombreCompleto, Cadena_Vacia) LIKE CONCAT("%", Cadena_Vacia, "%")
        OR  IFNULL(Dir.NombreCompleto, Cadena_Vacia) LIKE CONCAT("%", Cadena_Vacia, "%"))
        AND Dir.AvalRelacion <> Entero_Cero
        AND  Dir.GaranteID = Par_NumGarante)
        UNION
    (SELECT DirectivoID,  Dir.NombreCompleto
    FROM    DIRECTIVOS Dir
        WHERE Dir.DirectivoID <> Entero_Cero AND
        Dir.RelacionadoID = Entero_Cero AND Dir.GaranteRelacion= Entero_Cero AND Dir.AvalRelacion=Entero_Cero
        AND  Dir.GaranteID = Par_NumGarante)
    ORDER BY DirectivoID ASC
    LIMIT 0, 15;

END IF;

IF(Par_NumLis = Lis_Principal AND Par_NumAval <> Entero_Cero) THEN

    (SELECT DirectivoID,  Cli.NombreCompleto
        FROM    DIRECTIVOS Dir
        INNER JOIN CLIENTES Cli ON Dir.RelacionadoID = Cli.ClienteID
        AND (IFNULL(Cli.NombreCompleto, Cadena_Vacia) LIKE CONCAT("%", Cadena_Vacia, "%")
        OR  IFNULL(Dir.NombreCompleto, Cadena_Vacia) LIKE CONCAT("%", Cadena_Vacia, "%"))
        AND Dir.RelacionadoID <> Entero_Cero
        AND Dir.AvalID = Par_NumAval)
        UNION
    (SELECT DirectivoID,  Gar.NombreCompleto
        FROM    DIRECTIVOS Dir
        INNER JOIN GARANTES Gar ON Dir.GaranteRelacion = Gar.GaranteID
        AND (IFNULL(Gar.NombreCompleto, Cadena_Vacia) LIKE CONCAT("%", Cadena_Vacia, "%")
        OR  IFNULL(Dir.NombreCompleto, Cadena_Vacia) LIKE CONCAT("%", Cadena_Vacia, "%"))
        AND Dir.GaranteRelacion <> Entero_Cero
        AND Dir.AvalID = Par_NumAval)
        UNION
    (SELECT DirectivoID,  Ava.NombreCompleto
        FROM    DIRECTIVOS Dir
        INNER JOIN AVALES Ava ON Dir.AvalRelacion = Ava.AvalID
        AND (IFNULL(Ava.NombreCompleto, Cadena_Vacia) LIKE CONCAT("%", Cadena_Vacia, "%")
        OR  IFNULL(Dir.NombreCompleto, Cadena_Vacia) LIKE CONCAT("%", Cadena_Vacia, "%"))
        AND Dir.AvalRelacion <> Entero_Cero
        AND Dir.AvalID = Par_NumAval)
        UNION
    (SELECT DirectivoID,  Dir.NombreCompleto
    FROM    DIRECTIVOS Dir
        WHERE Dir.DirectivoID <> Entero_Cero AND
        Dir.RelacionadoID = Entero_Cero AND Dir.GaranteRelacion= Entero_Cero AND Dir.AvalRelacion=Entero_Cero
        AND Dir.AvalID = Par_NumAval)
    ORDER BY DirectivoID ASC
    LIMIT 0, 15;

END IF;

END TerminaStore$$