-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNEXIGIBLEGRUPOALDIA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNEXIGIBLEGRUPOALDIA`;DELIMITER $$

CREATE FUNCTION `FNEXIGIBLEGRUPOALDIA`(
	# FUNCION QUE DEVUELVE EL EXIGIBLE DE UN GRUPO
    Par_GrupoID		INT(11),	# Numero de Grupo
    Par_CicloGrupo	INT(11)		# Numero de Ciclo


) RETURNS decimal(16,2)
    DETERMINISTIC
BEGIN

DECLARE Var_MontoExigible DECIMAL(14,2);
DECLARE Var_FecActual       DATE;
DECLARE Var_ComAperProg 		DECIMAL(14,2);
DECLARE Var_CicloActual 		INT;
DECLARE Mon_TotDeuda    		DECIMAL(14,2);



DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(14,2);
DECLARE Esta_Activo     		CHAR(1);
DECLARE Esta_Vencido    		CHAR(1);
DECLARE Esta_Vigente    		CHAR(1);
DECLARE Si_Prorratea    char(1);


SET Cadena_Vacia    := '';					-- Constante: Cadena Vacia
SET Fecha_Vacia     := '1900-01-01';		-- Constante: Fecha Vacia
SET Entero_Cero     := 0;					-- Constante: Entero Cero
SET Decimal_Cero    := 0.00;				-- Constante: Decimal Cero
SET Esta_Activo     		:= 'A';                 -- Integrante Activo
SET Esta_Vencido    		:= 'B';                 -- Estatus del Credito Vencido
SET Esta_Vigente    		:= 'V';                 -- Estatus del Credito Vigente
SET Si_Prorratea    		:= 'S';                 -- Si Prorratea el Pago en el Grupo

SET Var_MontoExigible   := Decimal_Cero;

	SELECT SUM(case WHEN CLI.PagaIVA='S' THEN  (MontoComApert-ComAperPagado)+(MontoComApert-ComAperPagado)*SUC.IVA
					ELSE (MontoComApert-ComAperPagado) END)
			INTO Var_ComAperProg
		FROM CREDITOS CRE
			INNER JOIN CLIENTES CLI
				ON CRE.ClienteID=CLI.ClienteID
			INNER JOIN SUCURSALES SUC
				ON CLI.SucursalOrigen = SUC.SucursalID
		WHERE GrupoID=Par_GrupoID
		AND ForCobroComAper='P';

		SELECT CicloActual INTO Var_CicloActual
			FROM 	GRUPOSCREDITO
			WHERE  	GrupoID = Par_GrupoID;

		SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

		-- Verificamos el Ciclo del Grupo, Si es el Ciclo Actual o si es un Ciclo Anterior
		-- Entonces Buscamos los Integrantes en el Historico
		IF(Par_CicloGrupo = Var_CicloActual) THEN
			SELECT  SUM(FUNCIONCONPAGOANTCRE(Cre.CreditoID))
					INTO Mon_TotDeuda
				FROM INTEGRAGRUPOSCRE Ing,
					 SOLICITUDCREDITO Sol,
					 CREDITOS Cre
				WHERE Ing.GrupoID               = Par_GrupoID
				  AND Ing.Estatus               = Esta_Activo
				  AND Ing.ProrrateaPago         = Si_Prorratea
				  AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
				  AND Sol.CreditoID             = Cre.CreditoID
				  AND	(   Cre.Estatus		= Esta_Vigente
					   OR  Cre.Estatus		= Esta_Vencido	);
		ELSE
			SELECT  SUM(FUNCIONCONPAGOANTCRE(Cre.CreditoID))
					INTO Mon_TotDeuda
				FROM `HIS-INTEGRAGRUPOSCRE` Ing,
					 SOLICITUDCREDITO Sol,
					 CREDITOS Cre
				WHERE Ing.GrupoID               = Par_GrupoID
				  AND Ing.Estatus               = Esta_Activo
				  AND Ing.ProrrateaPago         = Si_Prorratea
				  AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
				  AND Ing.Ciclo                 = Par_CicloGrupo
				  AND Sol.CreditoID             = Cre.CreditoID
				  AND	(   Cre.Estatus		= Esta_Vigente
					   OR  Cre.Estatus		= Esta_Vencido	);
		END IF;

        SET Var_ComAperProg := IFNULL(Var_ComAperProg,Entero_Cero);

		SET Mon_TotDeuda        := IFNULL(Mon_TotDeuda, Entero_Cero) + Var_ComAperProg;


RETURN Mon_TotDeuda;

END$$