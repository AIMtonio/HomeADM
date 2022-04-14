-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before AND after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECALCULOCICLOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECALCULOCICLOPRO`;
DELIMITER $$


CREATE PROCEDURE `CRECALCULOCICLOPRO`(
	Par_ClienteID			BIGINT(20),			-- Parametro del numero de cliente
	Par_ProspectoID			BIGINT(20),			-- Parametro del numero de prospecto
	Par_ProductoCreditoID	INT(11),			-- Parametro del producto de credito
	Par_GrupoID				INT(11),			-- Parametro el id del grupo
	OUT Par_CicloCliente	INT(11),			-- Parametro del ciclo del cliente

	OUT Par_CicloPondGrupo	INT(11),			-- Parametro del ciclo ponderador
	Par_Salida				CHAR(1),			-- Tipo de Salida S.- Si N.- No

	Aud_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_NumCreditos		INT;
	DECLARE Var_EsGrupal        CHAR(1);
	DECLARE Var_PonderaTasa     CHAR(1);
	DECLARE Var_NumIntegrantes  INT;
	DECLARE Var_NumCredAnt      INT;
	DECLARE Var_CiclosBase      INT;
	DECLARE Var_CicBaseCli      INT;
	DECLARE Var_Control			VARCHAR(20);
	DECLARE Par_NumErr			INT(11);
	DECLARE Par_ErrMen			VARCHAR(400);
	DECLARE Var_CicloGrupalCte	INT(11);
	DECLARE Var_ValidaGrupo		CHAR(1);

	-- Declaracion de constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Cero			INT;
	DECLARE Fecha_Vacia			DATE;
	DECLARE Salida_SI			CHAR(1);
	DECLARE Salida_NO			CHAR(1);
	DECLARE Est_Vigente			CHAR(1);
	DECLARE Est_Pagado			CHAR(1);
	DECLARE EsGrupal_SI			CHAR(1);
	DECLARE PonderaTasa_SI		CHAR(1);
	DECLARE Inte_Activo			CHAR(1);
	DECLARE Est_Vencido			CHAR(1);
	DECLARE Con_SI				CHAR(1);

	-- Asignacion de constantes
	SET Cadena_Vacia        := '';
	SET Fecha_Vacia         := '1900-01-01';
	SET Entero_Cero         := 0;
	SET Salida_SI           := 'S';
	SET Salida_NO           := 'N';
	SET Est_Vigente         := 'V';
	SET Est_Pagado          := 'P';
	SET EsGrupal_SI         := 'S';
	SET PonderaTasa_SI      := 'S';
	SET Inte_Activo         := 'A';
	SET Est_Vencido			:= 'B';
	SET Con_SI				:= 'S';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
				SET Par_NumErr	:= 999;
				SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECALCULOCICLOPRO');
				SET Var_Control	:= 'SQLEXCEPTION';
		END;

			SET Par_CicloCliente    := IFNULL(Par_CicloCliente, Entero_Cero);
			SET Par_CicloPondGrupo  := IFNULL(Par_CicloPondGrupo, Entero_Cero);
			SET Par_ClienteID       := IFNULL(Par_ClienteID, Entero_Cero);
			SET Par_ProspectoID     := IFNULL(Par_ProspectoID, Entero_Cero);

			SET Var_NumCreditos     := Entero_Cero;
			SET Var_NumIntegrantes  := Entero_Cero;
			SET Var_NumCredAnt      := Entero_Cero;
			SET Var_CicBaseCli      := Entero_Cero;
			-- Obtenemos la bandera si valida el ciclo del grupo
			SET Var_ValidaGrupo		:= (SELECT ValidaCicloGrupo FROM PARAMETROSSIS);
			SET Var_ValidaGrupo		:= IFNULL(Var_ValidaGrupo, Cadena_Vacia);


			-- Se obtiene todos los creditos del cliente en curso
			SELECT COUNT(CreditoID) INTO Var_NumCreditos
				FROM CREDITOS Cre
				WHERE Cre.ClienteID		= Par_ClienteID
					AND Cre.ProductoCreditoID =  Par_ProductoCreditoID
					AND ( Cre.Estatus   = Est_Vigente
						OR Cre.Estatus   = Est_Pagado
						OR Cre.Estatus   = Est_Vencido);


			-- Le sumamos uno
			SET Var_NumCreditos := IFNULL(Var_NumCreditos, Entero_Cero) + 1;

			-- Consultamos el ciclo de base cuando es cliente
			IF(Par_ClienteID != Entero_Cero) THEN
				SELECT  CicloBase INTO Var_CicBaseCli
					FROM CICLOBASECLIPRO Cib
					WHERE Cib.ClienteID = Par_ClienteID
					AND Cib.ProductoCreditoID = Par_ProductoCreditoID;
			ELSE -- Cuando es prospecto
				SELECT  CicloBase INTO Var_CicBaseCli
					FROM CICLOBASECLIPRO Cib
					WHERE Cib.ProspectoID = Par_ProspectoID
					AND Cib.ProductoCreditoID = Par_ProductoCreditoID;

			END IF;

			--  ========= Sumamos el ciclo del cliente Total de Creditos + Ciclo Base ========
			SET Var_CicBaseCli := IFNULL(Var_CicBaseCli, Entero_Cero);
			SET Par_CicloCliente := Var_NumCreditos + Var_CicBaseCli;

			-- Obtenemos si el producto es grupal para obtener su tasa ponderada
			SELECT  Pro.EsGrupal, TasaPonderaGru INTO Var_EsGrupal, Var_PonderaTasa
				FROM PRODUCTOSCREDITO Pro
				WHERE Pro.ProducCreditoID   = Par_ProductoCreditoID;

			SET Var_EsGrupal    := IFNULL(Var_EsGrupal, Cadena_Vacia);
			SET Var_PonderaTasa := IFNULL(Var_PonderaTasa, Cadena_Vacia);

			-- Cuando la bandera que valida el ciclo del grupo se encuentre encendida y el producto es grupal
			-- Obtenemos el ciclo del cliente de la tabla correspondiente
			IF(Var_ValidaGrupo = Con_SI AND Var_EsGrupal = EsGrupal_SI)THEN
				-- Consultamos el ciclo cuando es cliente
				IF(Par_ClienteID <> Entero_Cero) THEN
					SELECT	CicloBase
					INTO	Var_CicloGrupalCte
					FROM CICLOSCTEGRUPAL
					WHERE ClienteID = Par_ClienteID;
				ELSE -- Cuando es prospecto
					SELECT	CicloBase
					INTO	Var_CicloGrupalCte
					FROM CICLOSCTEGRUPAL
					WHERE ProspectoID = Par_ProspectoID;
				END IF;

				SET Var_CicloGrupalCte	:= IFNULL(Var_CicloGrupalCte, Entero_Cero);
				SET Par_CicloCliente	:= IF(Var_CicloGrupalCte > Entero_Cero, Var_CicloGrupalCte, Par_CicloCliente);
			END IF;

			-- ============= SECCION PARA PRODUCTOS GRUPALES ======================
			IF(Var_EsGrupal = EsGrupal_SI AND Var_PonderaTasa = PonderaTasa_SI) THEN
				SET Par_CicloPondGrupo  := Entero_Cero;

				SELECT COUNT(DISTINCT Ing.SolicitudCreditoID), (IFNULL(COUNT(Cre.CreditoID), Entero_Cero))
						INTO  Var_NumIntegrantes, Var_NumCredAnt
					FROM INTEGRAGRUPOSCRE Ing
					LEFT OUTER JOIN CREDITOS Cre ON Cre.ClienteID = IFNULL(Ing.ClienteID, Entero_Cero)
													AND Cre.ProductoCreditoID =  Par_ProductoCreditoID
													AND ( Cre.Estatus   = Est_Vigente
													OR   Cre.Estatus   = Est_Pagado )
					WHERE Ing.GrupoID = Par_GrupoID
					AND Ing.Estatus = Inte_Activo
					GROUP BY Ing.GrupoID;

				SET Var_NumIntegrantes  := IFNULL(Var_NumIntegrantes, Entero_Cero);


				SET Var_NumCredAnt      := IFNULL(Var_NumCredAnt, Entero_Cero) + Var_NumIntegrantes;

				SELECT SUM(Cib.CicloBase) INTO Var_CiclosBase
					FROM INTEGRAGRUPOSCRE Ing
					INNER JOIN SOLICITUDCREDITO Sol ON Sol.SolicitudCreditoID = Ing.SolicitudCreditoID
					LEFT OUTER JOIN CICLOBASECLIPRO Cib ON ( CASE WHEN IFNULL(Cib.ClienteID, 0) > 0 THEN
																	IFNULL(Cib.ClienteID, 0)
																ELSE IFNULL(Cib.ProspectoID, 0) END)

														=  ( CASE WHEN IFNULL(Ing.ClienteID, 0) > 0 THEN
																	IFNULL(Ing.ClienteID, 0)
																ELSE IFNULL(Ing.ProspectoID, 0) END)

														AND Cib.ProductoCreditoID = Par_ProductoCreditoID
					WHERE Ing.GrupoID = Par_GrupoID
					AND Ing.Estatus = Inte_Activo
					GROUP BY Ing.GrupoID;

				SET Var_CiclosBase  := IFNULL(Var_CiclosBase, Entero_Cero);


				IF(Par_ClienteID != Entero_Cero) THEN
					IF (NOT EXISTS(SELECT Ing.GrupoID
								FROM INTEGRAGRUPOSCRE Ing
								WHERE Ing.GrupoID = Par_GrupoID
								AND Ing.Estatus = Inte_Activo
								AND Ing.ClienteID = Par_ClienteID)  )  THEN

						SET Var_CiclosBase  := Var_CiclosBase + Par_CicloCliente;
						SET Var_NumIntegrantes  := Var_NumIntegrantes + 1;
					END IF;
				ELSE
					IF (NOT EXISTS(SELECT Ing.GrupoID
								FROM INTEGRAGRUPOSCRE Ing
								WHERE Ing.GrupoID = Par_GrupoID
								AND Ing.Estatus = Inte_Activo
								AND Ing.ProspectoID = Par_ProspectoID)  )  THEN

						SET Var_CiclosBase  := Var_CiclosBase + Par_CicloCliente;
						SET Var_NumIntegrantes  := Var_NumIntegrantes + 1;
					END IF;
				END IF;

				SET Par_CicloPondGrupo  :=  ROUND((Var_NumCredAnt +  Var_CiclosBase) / (Var_NumIntegrantes), 0);
			END IF;

		SET	Par_NumErr	:= 0;
		SET	Par_ErrMen	:= CONCAT('Proceso Realizado Exitosamente: ', CONVERT(Par_CicloCliente,CHAR));
		SET Var_Control	:= 'cicloCliente';

END ManejoErrores;

 IF (Par_Salida = Salida_SI) THEN
	SELECT  Par_ClienteID AS ClienteID,
			Par_ProductoCreditoID AS ProductoCreditoID,
			Par_GrupoID AS GrupoID,
			Par_CicloCliente AS CicloCliente,
			Par_CicloPondGrupo AS CicloPondGrupo;

END IF;

END TerminaStore$$