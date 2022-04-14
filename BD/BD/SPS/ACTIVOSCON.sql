-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACTIVOSCON`;

DELIMITER $$
CREATE PROCEDURE `ACTIVOSCON`(
	# =====================================================================================
	# ------- STORED PARA CONSULTA DE ACTIVOS ---------
	# =====================================================================================
	Par_ActivoID            INT(11),        -- Idetinficador del activo
	Par_NumCon          TINYINT UNSIGNED,   -- Numero de consulta

	Par_EmpresaID           INT(11),        -- Parametro de auditoria ID de la empresa
	Aud_Usuario             INT(11),        -- Parametro de auditoria ID del usuario
	Aud_FechaActual         DATETIME,       -- Parametro de auditoria Fecha actual
	Aud_DireccionIP         VARCHAR(15),    -- Parametro de auditoria Direccion IP
	Aud_ProgramaID          VARCHAR(50),    -- Parametro de auditoria Programa
	Aud_Sucursal            INT(11),        -- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion      BIGINT(20)      -- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES

	DECLARE Var_DepreAmortiID   INT(11);
	DECLARE Var_EsEditable      CHAR(1);            -- variable para identificar si el activo ya fue depreciado

	-- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia        CHAR(1);            -- Constante cadena vacia ''
	DECLARE Fecha_Vacia         DATE;               -- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero         INT(1);             -- Constante Entero cero 0
	DECLARE Decimal_Cero        DECIMAL(14,2);      -- DECIMAL cero
	DECLARE Con_Activo          INT(11);            -- Consulta 1: activo

	DECLARE Cons_SI             CHAR(1);
	DECLARE Cons_NO             CHAR(1);

	-- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia            := '';
	SET Fecha_Vacia             := '1900-01-01';
	SET Entero_Cero             := 0;
	SET Decimal_Cero            := 0.0;
	SET Con_Activo              := 1;

	SET Cons_SI                 := 'S';
	SET Cons_NO                 := 'N';

	-- Consulta 1
	IF(Par_NumCon = Con_Activo) THEN

		SELECT  ACT.ActivoID,           ACT.TipoActivoID,       ACT.Descripcion,            ACT.FechaAdquisicion,       ACT.ProveedorID,
				ACT.NumFactura,         ACT.NumSerie,           ACT.Moi,                    ACT.DepreciadoAcumulado,    ACT.TotalDepreciar,
				ACT.MesesUso,           ACT.PolizaFactura,      ACT.CentroCostoID,          ACT.CtaContable,            ACT.Estatus,
				ACT.TipoRegistro,       ACT.FechaRegistro,      CASE WHEN ACT.EsDepreciado = Cons_SI THEN Cons_NO
																	 ELSE Cons_SI END AS EsEditable,
				ACT.NumeroConsecutivo,  ACT.PorDepFiscal,       ACT.DepFiscalSaldoInicio,   ACT.DepFiscalSaldoFin,		ACT.CtaContableRegistro
		FROM ACTIVOS ACT
		WHERE  ACT.ActivoID = Par_ActivoID;

	END IF;

END TerminaStore$$