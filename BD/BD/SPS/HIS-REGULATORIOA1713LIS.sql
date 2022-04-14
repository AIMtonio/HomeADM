-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-REGULATORIOA1713LIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `HIS-REGULATORIOA1713LIS`;DELIMITER $$

CREATE PROCEDURE `HIS-REGULATORIOA1713LIS`(


    Par_Fecha           VARCHAR(13),
    Par_NumLis          TINYINT UNSIGNED,


    Aud_Empresa         INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
    )
TerminaStore: BEGIN

DECLARE Principal       INT;
DECLARE Rep_Excel       INT;
DECLARE Rep_CSV         INT;
DECLARE Var_Fecha       INT;
DECLARE Cadena_Vacia    CHAR;
DECLARE Var_FechaM      INT;
DECLARE Var_FechaI      INT;

SET Principal       := 1;
SET Rep_Excel       := 2;
SET Rep_CSV         := 3;
SET Cadena_Vacia    := '';

SELECT REPLACE (CONVERT(Par_Fecha,CHAR),'-',Cadena_Vacia) INTO Var_Fecha;



IF(Par_NumLis = Principal) THEN

    SELECT DISTINCT
    Fecha,                  ClaveEntidad,       Subreporte,     TipoMovimiento,         NombreFuncionario,
    RFC,                    CURP,               Profesion,      CalleDomicilio,         NumeroExt,
    NumeroInt,              ColoniaDomicilio,   CodigoPostal,   Localidad,              Estado,
    Pais,                   Telefono,           Email,          STR_TO_DATE(FechaMovimiento,'%Y%m%d')
    AS FechaMovimiento,STR_TO_DATE(FechaInicio,'%Y%m%d') AS FechaInicio,
    OrganoPerteneciente,    Cargo,              Permanente,     ManifestCumplimiento,   Municipio
    FROM `HIS-REGULATORIOA1713` WHERE Fecha = Var_Fecha;

END IF;

IF(Par_NumLis = Rep_Excel) THEN

    DROP TABLE IF EXISTS TMP_GRADOESTUDIOS;
    CREATE TEMPORARY TABLE TMP_GRADOESTUDIOS(
        GradoEstudiosID      VARCHAR(50),
        Descripcion          VARCHAR(250)
    );

    INSERT INTO TMP_GRADOESTUDIOS SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 16;

    DROP TABLE IF EXISTS TMP_CARGO;
    CREATE TEMPORARY TABLE TMP_CARGO(
        CargoID             VARCHAR(50),
        Descripcion         VARCHAR(250)
    );

    INSERT INTO TMP_CARGO SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 6;

    DROP TABLE IF EXISTS TMP_MANIFESTACION;
    CREATE TEMPORARY TABLE TMP_MANIFESTACION(
        ManifestacionID     VARCHAR(50),
        Descripcion         VARCHAR(250)
    );

    INSERT INTO TMP_MANIFESTACION SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 7;



    DROP TABLE IF EXISTS TMP_ORGANO;
    CREATE TEMPORARY TABLE TMP_ORGANO(
        OrganoID        VARCHAR(50),
        Descripcion         VARCHAR(250)
    );

    INSERT INTO TMP_ORGANO SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 8;



    DROP TABLE IF EXISTS TMP_PERMANENTE;
    CREATE TEMPORARY TABLE TMP_PERMANENTE(
        PermanenteID        VARCHAR(50),
        Descripcion         VARCHAR(250)
    );

    INSERT INTO TMP_PERMANENTE SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 9;

    DROP TABLE IF EXISTS TMP_TIPOMOVIMIENTO;
    CREATE TEMPORARY TABLE TMP_TIPOMOVIMIENTO(
        TipoMovimientoID        VARCHAR(50),
        Descripcion         VARCHAR(250)
    );

    INSERT INTO TMP_TIPOMOVIMIENTO SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 17;

    SELECT
    His.Fecha,                                  His.ClaveEntidad,               His.Subreporte,                     Tip.Descripcion AS TipoMovimiento,          His.NombreFuncionario,
    His.RFC,                                    His.CURP,                       Gra.Descripcion AS Profesion,       His.CalleDomicilio,                         His.NumeroExt,
    His.NumeroInt,                              His.ColoniaDomicilio,           His.CodigoPostal,                   His.Localidad,                              His.Estado,
    His.Pais,                                   His.Telefono,                   His.Email,                          His.FechaMovimiento,                        His.FechaInicio,
    Org.Descripcion AS OrganoPerteneciente,     Car.Descripcion AS Cargo,       Per.Descripcion AS Permanente,      Man.Descripcion AS ManifestCumplimiento,    His.Municipio,
    Col.Asentamiento AS Asentamiento,           Pais.Nombre AS NombrePais,      Edo.Nombre AS NombreEstado,         Col.Asentamiento AS NombreLocalidad

    FROM `HIS-REGULATORIOA1713` His                         INNER JOIN TMP_GRADOESTUDIOS    Gra
    ON His.Profesion                = Gra.GradoEstudiosID   INNER JOIN TMP_CARGO            Car
    ON His.Cargo                    = Car.CargoID           INNER JOIN TMP_MANIFESTACION    Man
    ON His.ManifestCumplimiento     = Man.ManifestacionID   INNER JOIN TMP_ORGANO           Org
    ON His.OrganoPerteneciente      = Org.OrganoID          INNER JOIN TMP_PERMANENTE       Per
    ON His.Permanente               = Per.PermanenteID      INNER JOIN TMP_TIPOMOVIMIENTO   Tip
    ON His.TipoMovimiento           = Tip.TipoMovimientoID  INNER JOIN COLONIASREPUB        Col
    ON His.ColoniaDomicilio         = Col.ColoniaID         AND His.Estado=Col.EstadoID AND His.Municipio=Col.MunicipioID
                                                            INNER JOIN PAISES               Pais
    ON His.Pais                     = Pais.PaisCNBV         INNER JOIN ESTADOSREPUB         Edo
    ON His.Estado                   = Edo.EstadoID
    WHERE His.Fecha = Var_Fecha   ORDER BY His.Consecutivo;
END IF;

IF(Par_NumLis = Rep_CSV) THEN
    SELECT CONCAT(
    His.TipoMovimiento,';',         His.NombreFuncionario,';',
    His.RFC,';',                    His.CURP,';',           His.Profesion,';',      His.CalleDomicilio,';',       His.NumeroExt,';',
    His.NumeroInt,';',              Col.Asentamiento,';',   His.CodigoPostal,';',   His.Localidad,';',            His.Estado,';',
    His.Pais,';',                   His.Telefono,';',       LOWER(His.Email),';',   His.FechaMovimiento,';',      His.FechaInicio,';',
    His.OrganoPerteneciente,';',    His.Cargo,';',          His.Permanente,';',     His.ManifestCumplimiento,';', His.Municipio,';') AS Renglon
    FROM `HIS-REGULATORIOA1713` His INNER JOIN COLONIASREPUB Col ON His.ColoniaDomicilio=Col.ColoniaID AND His.Estado=Col.EstadoID AND His.Municipio=Col.MunicipioID
    WHERE His.Fecha = Var_Fecha ORDER BY His.Consecutivo;
END IF;

END TerminaStore$$