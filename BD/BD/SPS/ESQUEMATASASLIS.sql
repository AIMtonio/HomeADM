-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMATASASLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMATASASLIS`;DELIMITER $$

CREATE PROCEDURE `ESQUEMATASASLIS`(
# =====================================================================================
# ------- STORED PARA TRAER LA LISTA DE ESQUEMA DE LAS TASAS ---------
# =====================================================================================
  Par_SucursalID      INT(11),      -- Numero de sucursal
  Par_ProdCreID     INT(11),      -- Producto de credito
    Par_MontoCre      INT(11),
  Par_Calificacion    CHAR(1),
  Par_PlazoID       VARCHAR(20),

  Par_TasaFija      DECIMAL(12,2),
  Par_InstNomID     INT(11),
  Par_NumLis        TINYINT UNSIGNED, -- Numero de lista

  /*Auditoria*/
    Par_EmpresaID         INT(11),      -- Parametro de auditoria ID de la empresa
    Aud_Usuario           INT(11),      -- Parametro de auditoria ID del usuario
    Aud_FechaActual       DATETIME,     -- Parametro de auditoria Fecha actual
    Aud_DireccionIP       VARCHAR(15),    -- Parametro de auditoria Direccion IP
    Aud_ProgramaID        VARCHAR(50),    -- Parametro de auditoria Programa
    Aud_Sucursal          INT(11),      -- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion    BIGINT(20)      -- Parametro de auditoria Numero de la transaccion

    )
TerminaStore: BEGIN

  -- Declaracion de Constantes
  DECLARE Lis_Principal INT;
  DECLARE Cadena_Vacia  CHAR(1);
    DECLARE List_TasaVar  INT;
    DECLARE Entero_Cero   INT;
    DECLARE Plazo_Todos   CHAR(1);

  -- Asinacion de Constantes
  SET Cadena_Vacia  := '';
  SET Lis_Principal := 1;
    SET List_TasaVar  := 2;
    SET Entero_Cero   := 0;
    SET Plazo_Todos   := 'T';

  /*LISTA PRINCIPAL*/
  IF(Par_NumLis = Lis_Principal) THEN
    SELECT    Esq.SucursalID,       Esq.ProductoCreditoID,        Esq.MinCredito,   Esq.MaxCredito,
          CASE WHEN Calificacion='N'  THEN 'NO ASIGNADA'
            WHEN Calificacion='A'   THEN 'EXCELENTE'
            WHEN Calificacion='B'   THEN 'BUENA'
            WHEN Calificacion='C'   THEN 'REGULAR'END AS Calificacion,
          Esq.MontoInferior,      Esq.MontoSuperior,
          CASE Esq.PlazoID
            WHEN 'T' THEN 'TODOS'
            ELSE CP.Descripcion END AS PlazoID,
          Esq.TasaFija,       Esq.SobreTasa,            Esq.InstitNominaID,
          IF(Esq.InstitNominaID = 0, 'TODAS', IFNULL(Intn.NombreInstit,Cadena_Vacia)) AS NombreInst,
          P.ProductoNomina, CASE WHEN Esq.NivelID = 0 THEN 'TODAS' ELSE NIV.Descripcion END AS DescripcionNivel, Esq.NivelID,P.CalcInteres
      FROM  ESQUEMATASAS Esq
        INNER JOIN PRODUCTOSCREDITO P
          ON Esq.ProductoCreditoID = P.ProducCreditoID
        LEFT OUTER JOIN CREDITOSPLAZOS CP
          ON  CP.PlazoID = Esq.PlazoID
        LEFT OUTER JOIN INSTITNOMINA AS Intn
          ON Esq.InstitNominaID = Intn.InstitNominaID
        LEFT JOIN NIVELCREDITO NIV
          ON Esq.NivelID = NIV.NivelID
      WHERE   SucursalID      = Par_SucursalID
      AND   ProductoCreditoID = Par_ProdCreID
      ORDER BY Calificacion, MaxCredito;
  ELSEIF (Par_NumLis = List_TasaVar) THEN
    SELECT Esq.SucursalID,    Esq.ProductoCreditoID,    Esq.MinCredito,   Esq.MaxCredito,   Esq.Calificacion,
      Esq.MontoInferior,    Esq.MontoSuperior,      Esq.PlazoID,    Esq.TasaFija,       FORMAT(Esq.SobreTasa,4) AS SobreTasa,
            Esq.InstitNominaID,   Cadena_Vacia AS NombreInst, Cadena_Vacia AS ProductoNomina,
            Cadena_Vacia AS DescripcionNivel,   Esq.NivelID,  Cadena_Vacia AS CalcInteres
        FROM ESQUEMATASAS Esq
        WHERE SucursalID    = Par_SucursalID
    AND ProductoCreditoID   = Par_ProdCreID
        AND Par_MontoCre BETWEEN MontoInferior AND MontoSuperior
        AND Calificacion    = Par_Calificacion
        AND CASE WHEN PlazoID = Plazo_Todos THEN (PlazoID = Plazo_Todos) ELSE  (PlazoID = Par_PlazoID) END
        AND TasaFija      = Par_TasaFija
        AND InstitNominaID    = Par_InstNomID;
    END IF;
END TerminaStore$$