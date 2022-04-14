-- SP CONOCIMIENTOUSUSERVCON

DELIMITER ;
DROP PROCEDURE IF EXISTS `CONOCIMIENTOUSUSERVCON`;

DELIMITER $$
CREATE PROCEDURE `CONOCIMIENTOUSUSERVCON`(
    -- Stored procedure para consultar conocimientos del usuario de servicios.
    -- Pantalla: Prevencion LD > Registro > Conocimiento Usuario Servicios.
    Par_UsuarioServicioID       BIGINT(11),             -- Identificador del usuario de servicios.
    Par_NumCon			        TINYINT UNSIGNED,       -- Número de consulta que se realizará.

    Aud_EmpresaID               INT(11),                -- Parámetro de auditoría ID de la empresa.
    Aud_Usuario                 INT(11),                -- Parámetro de auditoría ID del usuario.
    Aud_FechaActual             DATETIME,               -- Parámetro de auditoría fecha actual.
    Aud_DireccionIP             VARCHAR(15),            -- Parámetro de auditoría direccion IP.
    Aud_ProgramaID              VARCHAR(50),            -- Parámetro de auditoría programa.
    Aud_Sucursal                INT(11),                -- Parámetro de auditoría ID de la sucursal.
    Aud_NumTransaccion          BIGINT(20)              -- Parámetro de auditoría numero de transaccion.
)
TerminaStore: BEGIN

    -- Declaración de constantes.
    DECLARE Entero_Cero         INT(11);        -- Constante número cero (0).
    DECLARE Con_Principal       INT(11);        -- Consulta principal (1).

    -- Asignación de constantes.
    SET Con_Principal       := 1;
    SET Entero_Cero         := 0;

    -- 1. Consulta principal para todos los datos de conocimiento de un usuario de servicios.
    -- Pantalla: Prevencion LD > Registro > Conocimiento Usuario Servicios.
    IF (Par_NumCon = Con_Principal) THEN

        SELECT
            CUS.UsuarioServicioID,      CUS.NombreGrupo,            CUS.RFC,                       CUS.Participacion,             CUS.Nacionalidad,
            CUS.RazonSocial,            CUS.Giro,                   CUS.AniosOperacion,            CUS.AniosGiro,                 CUS.PEPs,
            CUS.FuncionID,              FP.Descripcion AS FuncDesc, CUS.FechaNombramiento,         CUS.PorcentajeAcciones,        CUS.PeriodoCargo,
            CUS.MontoAcciones,          CUS.ParentescoPEP,          CUS.NombreFamiliar,            CUS.APaternoFamiliar,          CUS.AMaternoFamiliar,
            CUS.NumeroEmpleados,        CUS.ServiciosProductos,     CUS.CoberturaGeografica,       CUS.EstadosPresencia,          CUS.ImporteVentas,

            CUS.Activos,                CUS.Pasivos,                CUS.CapitalContable,           CUS.CapitalNeto,               CUS.Importa,
            CUS.DolaresImporta,         CUS.PaisesImporta1,         CUS.PaisesImporta2,            CUS.PaisesImporta3,            CUS.Exporta,
            CUS.DolaresExporta,         CUS.PaisesExporta1,         CUS.PaisesExporta2,            CUS.PaisesExporta3,            CUS.TiposClientes,
            CUS.InstrMonetarios,        CUS.NombreRefCom1,          CUS.NoCuentaRefCom1,           CUS.DireccionRefCom1,          CUS.TelefonoRefCom1,
            CUS.ExtTelefonoRefCom1,     CUS.NombreRefCom2,          CUS.NoCuentaRefCom2,           CUS.DireccionRefCom2,          CUS.TelefonoRefCom2,

            CUS.ExtTelefonoRefCom2,     CUS.BancoRefBanc1,          CUS.TipoCuentaRefBanc1,        CUS.NoCuentaRefBanc1,          CUS.SucursalRefBanc1,
            CUS.NoTarjetaRefBanc1,      CUS.InstitucionRefBanc1,    CUS.CredOtraEntRefBanc1,       CUS.InstitucionEntRefBanc1,    CUS.BancoRefBanc2,
            CUS.TipoCuentaRefBanc2,     CUS.NoCuentaRefBanc2,       CUS.SucursalRefBanc2,          CUS.NoTarjetaRefBanc2,         CUS.InstitucionRefBanc2,
            CUS.CredOtraEntRefBanc2,    CUS.InstitucionEntRefBanc2, CUS.NombreRefPers1,            CUS.DomicilioRefPers1,         CUS.TelefonoRefPers1,
            CUS.ExtTelefonoRefPers1,    CUS.TipoRelacionRefPers1,   TR1.Descripcion AS RelacDesc1, CUS.NombreRefPers2,            CUS.DomicilioRefPers2,

            CUS.TelefonoRefPers2,       CUS.ExtTelefonoRefPers2,    CUS.TipoRelacionRefPers2,      TR2.Descripcion AS RelacDesc2, CUS.PreguntaUsuario1,
            CUS.RespuestaUsuario1,      CUS.PreguntaUsuario2,       CUS.RespuestaUsuario2,         CUS.PreguntaUsuario3,          CUS.RespuestaUsuario3,
            CUS.PreguntaUsuario4,       CUS.RespuestaUsuario4,      CUS.PrincipalFuenteIng,        CUS.IngAproxPorMes,            CUS.EvaluaXMatriz,
            CUS.ComentarioNivel
        FROM CONOCIMIENTOUSUSERV CUS
        LEFT JOIN FUNCIONESPUB FP ON CUS.FuncionID = FP.FuncionID
        LEFT JOIN TIPORELACIONES TR1 ON TR1.TipoRelacionID = CUS.TipoRelacionRefPers1 AND TR1.TipoRelacionID > Entero_Cero
        LEFT JOIN TIPORELACIONES TR2 ON TR2.TipoRelacionID = CUS.TipoRelacionRefPers2 AND TR2.TipoRelacionID > Entero_Cero
        WHERE CUS.UsuarioServicioID = Par_UsuarioServicioID;
    END IF;

END TerminaStore$$