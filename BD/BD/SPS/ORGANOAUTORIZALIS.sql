-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORGANOAUTORIZALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ORGANOAUTORIZALIS`;
DELIMITER $$

CREATE PROCEDURE `ORGANOAUTORIZALIS`(
# ========================================================================================================================
# ------ SP PARA CONSULTAR LOS ORGANOS FACULTADOS PARA LA AUTORIZACION DE SOLICITUD DE CREDITOS --------------------------
# ========================================================================================================================
	Par_Esquema				INT(11),			# Numero de Esquema de la Solicitud de Credito
	Par_NumFirma			INT(11),			# Numero de Firma de la Solicitud de Credito
	Par_Organo				INT(11), 			# Numero de Organo de Autorizacion de la Solicitud de Credito
	Par_Producto			INT(11),			# Numero de Producto de Credito de la Solicitud de Credito
	Par_Solicitud			BIGINT(20),			# Numero de la Solicitud de Credito
	Par_NumLis				TINYINT UNSIGNED,   # Numero de Lista para el Esquema de Autorizacion de la Solicitud de Credito

    # Parametros de Auditoria
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
		)
TerminaStore: BEGIN

# Declaracion de Variables
DECLARE	Var_CicloActual		INT(11);				# Valor de Ciclo Actual para buscar el esquema de Autorizacion
DECLARE	Var_Cliente			INT(11);				# Numero de Cliente
DECLARE	Var_Esquema			INT(11);				# Llave principal de el Esquema de Autorizacion
DECLARE	Var_MontoSolicitado	DECIMAL(18,2);		    # Valor del Monto Solicitado en la Solicitud de Credito
DECLARE	Var_MontoMaximo		DECIMAL(18,2);			# Valor de Monto maximo del conjunto de solicitudes de un grupo para su autoirzacion
DECLARE Var_Prospecto		INT(11); -- Almacena el Prospecto
DECLARE Var_ProductoID		INT(11); -- Almacena el Producto

DECLARE	Var_EsGrupal		CHAR(1);				# Indica si la solicitud es de un producto Grupal
DECLARE	Var_NumGrupo		INT(11);				# Indica el Numero de Grupo en caso que la solicitud sea de un producto Grupal
DECLARE Var_TipoCredito		CHAR(1);				# Almacena el Tipo de credito: NUEVO, RENOVACION, REESTRUCTURA
DECLARE Var_CliProEsp   	INT;					# Almacena el Numero de Cliente para Procesos Especificos
DECLARE Var_EsquemaID       INT;					# Almacena el Maximo Esquema del Producto de Credito

# Declaracion de Constantes
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATETIME;
DECLARE Entero_Cero			INT(11);
DECLARE Str_SI				CHAR(1);
DECLARE Str_NO				CHAR(1);

DECLARE Sol_StaInactiva		CHAR(1);
DECLARE Sol_StaLiberada		CHAR(1);
DECLARE Sol_StaAutorizada	CHAR(1);
DECLARE Sol_StaCancelada	CHAR(1);
DECLARE Cre_StaPagado		CHAR(1);

DECLARE Cre_StaVigente		CHAR(1);
DECLARE Cre_StaVencido		CHAR(1);
DECLARE Con_CliProcEspe     VARCHAR(20);
DECLARE NumClienteYanga		INT;
DECLARE CreReestructura		CHAR(1);

DECLARE CreRenovacion		CHAR(1);
DECLARE	Lis_Principal		CHAR(1);
DECLARE	Lis_PorEsquema		CHAR(1);
DECLARE	Lis_PorProducto		CHAR(1);
DECLARE	Lis_PorProdUsu		CHAR(1);

DECLARE	Lis_PorProdSol		CHAR(1);
DECLARE	Lis_PorProdUsuFirma CHAR(1);


# Asignacion de Constantes
SET	Cadena_Vacia			:= '';					# Cadena Vacia
SET	Fecha_Vacia				:= '1900-01-01';		# Fecha Vacia
SET	Entero_Cero				:= 0;					# Entero Cero
SET	Str_SI					:= 'S';					# Cadena: SI
SET	Str_NO					:= 'N';					# Cadena: NO

SET	Sol_StaInactiva			:= 'I';					# Estatus de Solicitud Inactiva
SET	Sol_StaLiberada			:= 'L';					# Estatus de Solicitud Liberada
SET	Sol_StaAutorizada		:= 'A';					# Estatus de Solicitud Autorizada
SET	Sol_StaCancelada		:= 'C';					# Estatus de Solicitud: Cancelada
SET	Cre_StaPagado			:= 'P';					# Estatus de Credito: Liquidado

SET	Cre_StaVigente			:= 'V';					# Estatus de Credito: Vigente
SET	Cre_StaVencido			:= 'B';					# Estatus de Credito: Vencido
SET Con_CliProcEspe         := 'CliProcEspecifico'; # Parametro de Cliente para Procesos Especificos
SET NumClienteYanga			:= 4;					# Numero de Cliente Yanga para Procesos Especificos: 3
SET CreReestructura			:= 'R';					# Tipo de Credito: REESTRUCTURA

SET CreRenovacion			:= 'O';					# Tipo de Credito: RENOVACION
SET	Lis_Principal			:= 1;					# Lista todas las firmas parametrizadas
SET	Lis_PorEsquema			:= 2;					# Lista las firmas parametrizadas por un determinado Esquema
SET	Lis_PorProducto			:= 3;					# Lista las firmas parametrizadas de los Esquema de Autorizacion por Producto
SET	Lis_PorProdUsu			:= 4;					# Lista las firmas Pendientes que el usuario puede otorgar

SET	Lis_PorProdSol			:= 5;					# Lista las firmas que requiere una solicitud de acuerdo al esquema de autorizacion
SET Lis_PorProdUsuFirma     := 6;           		# Lista las firmas  filtrando por id de esquema de firma , producto de credito y usuario

#  1.- Lista todas las firmas parametrizadas
IF (Par_NumLis = Lis_Principal) THEN
	SELECT Fir.EsquemaID,	Fir.NumFirma,		Fir.OrganoID,		Org.Descripcion
	FROM ORGANOAUTORIZA Fir
	INNER JOIN ORGANODESICION Org ON Fir.OrganoID = Org.OrganoID
	ORDER BY Fir.EsquemaID, Fir.NumFirma, Fir.OrganoID ;
END IF;


#  2.- Lista las firmas parametrizadas por un determinado Esquema
IF (Par_NumLis = Lis_PorEsquema) THEN
	SELECT Fir.EsquemaID,	Fir.NumFirma,		Fir.OrganoID,		Org.Descripcion
	FROM ORGANOAUTORIZA Fir
	INNER JOIN ORGANODESICION Org ON Fir.OrganoID = Org.OrganoID
	WHERE Fir.EsquemaID = Par_Esquema
	ORDER BY Fir.EsquemaID, Fir.NumFirma, Fir.OrganoID ;
END IF;



#  3.- Lista las firmas parametrizadas de los Esquema de Autorizacion por Producto
IF (Par_NumLis = Lis_PorProducto) THEN
SELECT  Fir.EsquemaID,		Fir.NumFirma,		Fir.OrganoID,		Org.Descripcion
	FROM ESQUEMAAUTORIZA Esq
	INNER JOIN ORGANOAUTORIZA Fir ON Esq.EsquemaID = Fir.EsquemaID
	INNER JOIN ORGANODESICION Org ON Fir.OrganoID = Org.OrganoID
	WHERE   Esq.ProducCreditoID = Par_Producto
	ORDER BY Esq.CicloInicial, Esq.CicloFinal,
		Esq.MontoInicial, Esq.MontoFinal,
		Esq.MontoMaximo, Fir.NumFirma, Fir.OrganoID;
END IF;

#  4.- Lista las firmas Pendientes de una solicitud que el usuario puede otorgar
IF (Par_NumLis = Lis_PorProdUsu) THEN
	# Se obtiene el Numero de Cliente para Procesos Especificos
	SET Var_CliProEsp := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_CliProcEspe);
    SET Var_CliProEsp := IFNULL(Var_CliProEsp,Entero_Cero);

	# Obtenemos datos basicos de la solicitud
	SELECT	Sol.ClienteID,	Sol.MontoSolici,		Pro.EsGrupal,   Sol.TipoCredito, 	Sol.ProspectoID,	Sol.ProductoCreditoID
	INTO 	Var_Cliente,	Var_MontoSolicitado, 	Var_EsGrupal,	Var_TipoCredito,	Var_Prospecto,		Var_ProductoID
	FROM SOLICITUDCREDITO Sol
	INNER JOIN PRODUCTOSCREDITO Pro ON Sol.ProductoCreditoID = Pro.ProducCreditoID
	WHERE Sol.SolicitudCreditoID = Par_Solicitud;

	# Si el producto no es grupal el ciclo se determina por el Cliente
	IF IFNULL(Var_EsGrupal, Cadena_Vacia) = Str_NO THEN
		SET Var_MontoMaximo := Var_MontoSolicitado;

-- ============== NUEVA SECCION PARA OBTENER EL CICLO ============== --
		IF(Var_Cliente <> Entero_Cero)THEN
			SELECT CicloBase
				INTO Var_CicloActual
				FROM CICLOBASECLIPRO
					WHERE ProductoCreditoID=Var_ProductoID
						AND ClienteID=Var_Cliente
						ORDER BY NumTransaccion DESC
                        LIMIT 1;
		ELSE
			SELECT CicloBase
			INTO Var_CicloActual
            FROM CICLOBASECLIPRO
					WHERE ProductoCreditoID=Var_ProductoID
					AND ProspectoID=Var_Prospecto
					ORDER BY NumTransaccion DESC
                    LIMIT 1;
        END IF;

		SET	Var_CicloActual	:= IFNULL(Var_CicloActual , Entero_Cero);

		IF(Var_CicloActual = Entero_Cero) THEN

			SET Var_CicloActual	:= (SELECT COUNT(CreditoID)
								FROM CREDITOS
								WHERE	ClienteID	= Var_Cliente
								    AND	Estatus	IN (Cre_StaPagado, Cre_StaVigente, Cre_StaVencido) );
			# Oscar MAcias Solicito que cuando se calcule el ciclo siempre se debe sumar un 1
			SET	Var_CicloActual	:= IFNULL(Var_CicloActual, Entero_Cero) + 1;
		END IF;

	ELSE  # Si el producto si es grupal el ciclo se determina por el grupo
		SELECT	Gru.GrupoID,		Gru.CicloActual
		INTO		Var_NumGrupo,	Var_CicloActual
		FROM INTEGRAGRUPOSCRE  Inte
		INNER JOIN GRUPOSCREDITO  Gru ON Inte.GrupoID = Gru.GrupoID
		WHERE Inte.SolicitudCreditoID = Par_Solicitud;

		SET	Var_NumGrupo	:= IFNULL(Var_NumGrupo, Entero_Cero);
		SET	Var_CicloActual	:= IFNULL(Var_CicloActual, Entero_Cero);

		# Monto solicitado de todas las solicitudes que integran el grupo
		SET Var_MontoMaximo :=(SELECT SUM(Sol.MontoSolici)
							FROM INTEGRAGRUPOSCRE Inte
							INNER JOIN SOLICITUDCREDITO Sol ON Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
							WHERE Inte.GrupoID = Var_NumGrupo
							    AND Sol.Estatus IN (Sol_StaAutorizada, Sol_StaLiberada, Sol_StaCancelada) );

		SET	Var_MontoMaximo	:= IFNULL(Var_MontoMaximo, Entero_Cero);

	END IF;

	IF Var_MontoSolicitado <= Entero_Cero  OR  Var_CicloActual = Entero_Cero THEN
		LEAVE	TerminaStore;
	END IF;
	# Se obtiene el Esquema para Solicitudes de REESTRUCTURA Y RENOVACION para el cliente YANGA
	 IF (Var_CliProEsp = NumClienteYanga AND Var_TipoCredito IN(CreReestructura,CreRenovacion)) THEN
		SET Var_EsquemaID := (SELECT MAX(EsquemaID) FROM ESQUEMAAUTORIZA WHERE ProducCreditoID = Par_Producto);
			SELECT  Fir.EsquemaID,		Fir.NumFirma,		Fir.OrganoID,		Org.Descripcion
				FROM ESQUEMAAUTORIZA Esq
				INNER JOIN ORGANOAUTORIZA Fir ON Esq.EsquemaID = Fir.EsquemaID
				INNER JOIN ORGANODESICION Org ON Fir.OrganoID = Org.OrganoID
				WHERE Esq.ProducCreditoID = Par_Producto
				AND Esq.EsquemaID = Var_EsquemaID
				AND Fir.OrganoID IN (SELECT Org.OrganoID   -- organos en los que se encuentra el usuario y que puede autorizar
							FROM USUARIOS Usu
							INNER JOIN ORGANOINTEGRA Org ON Usu.ClavePuestoID = Org.ClavePuestoID
							WHERE UsuarioID = Aud_Usuario)
				AND Fir.NumFirma NOT IN (SELECT NumFirma -- firmas que ya fueron otorgadas
								FROM ESQUEMAAUTFIRMA
								WHERE SolicitudCreditoID = Par_Solicitud)
				ORDER BY Fir.NumFirma, Fir.OrganoID;
	ELSE  # Se obtiene el Esquema para solicitudes Nuevas
		SELECT  Fir.EsquemaID,	Fir.NumFirma,		Fir.OrganoID,		Org.Descripcion
		FROM ESQUEMAAUTORIZA Esq
		INNER JOIN ORGANOAUTORIZA Fir ON Esq.EsquemaID = Fir.EsquemaID
		INNER JOIN ORGANODESICION Org ON Fir.OrganoID = Org.OrganoID
		WHERE   Esq.ProducCreditoID = Par_Producto
			AND   Var_CicloActual >= Esq.CicloInicial
			AND   Var_CicloActual <= Esq.CicloFinal
			AND   Var_MontoSolicitado  >= Esq.MontoInicial
			AND   Var_MontoSolicitado  <= Esq.MontoFinal
			AND   Var_MontoMaximo <= Esq.MontoMaximo
			AND   Fir.OrganoID IN (SELECT Org.OrganoID   -- organos en los que se encuentra el usuario y que puede autorizar
							FROM USUARIOS Usu
							INNER JOIN ORGANOINTEGRA Org ON Usu.ClavePuestoID = Org.ClavePuestoID
							WHERE UsuarioID = Aud_Usuario)
			AND   Fir.NumFirma NOT IN (SELECT NumFirma -- firmas que ya fueron otorgadas
								FROM ESQUEMAAUTFIRMA
								WHERE SolicitudCreditoID = Par_Solicitud)
		ORDER BY Esq.CicloInicial, Esq.CicloFinal,  Esq.MontoInicial, Esq.MontoFinal,   Esq.MontoMaximo, Fir.NumFirma, Fir.OrganoID;
    END IF;

END IF;


--  5.- Lista las firmas que requiere una solicitud de acuerdo al esquema de autorizacion
IF (Par_NumLis = Lis_PorProdSol) THEN
	# Se obtiene el Numero de Cliente para Procesos Especificos
	SET Var_CliProEsp := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_CliProcEspe);
    SET Var_CliProEsp := IFNULL(Var_CliProEsp,Entero_Cero);

	# Obtenemos datos basicos de la solicitud
	SELECT Sol.ClienteID,	Sol.MontoSolici, 		Pro.EsGrupal,   Sol.TipoCredito,  	Sol.ProspectoID,	Sol.ProductoCreditoID
	INTO Var_Cliente,		Var_MontoSolicitado,	Var_EsGrupal,	Var_TipoCredito,	Var_Prospecto,		Var_ProductoID
	FROM SOLICITUDCREDITO Sol
	INNER JOIN PRODUCTOSCREDITO Pro ON Sol.ProductoCreditoID = Pro.ProducCreditoID
	WHERE Sol.SolicitudCreditoID = Par_Solicitud;

	# Si el producto no es grupal el ciclo se determina por el Cliente
	IF IFNULL(Var_EsGrupal, Cadena_Vacia) = Str_NO THEN
		SET Var_MontoMaximo := Var_MontoSolicitado;

-- ============== NUEVA SECCION PARA OBTENER EL CICLO ============== --
		IF(Var_Cliente <> Entero_Cero)THEN
			SELECT CicloBase
				INTO Var_CicloActual
				FROM CICLOBASECLIPRO
					WHERE ProductoCreditoID=Var_ProductoID
						AND ClienteID=Var_Cliente
						ORDER BY NumTransaccion DESC
                        LIMIT 1;
		ELSE
			SELECT CicloBase
			INTO Var_CicloActual
            FROM CICLOBASECLIPRO
					WHERE ProductoCreditoID=Var_ProductoID
					AND ProspectoID=Var_Prospecto
					ORDER BY NumTransaccion DESC
                    LIMIT 1;
        END IF;

		SET	Var_CicloActual	:= IFNULL(Var_CicloActual , Entero_Cero);

		IF(Var_CicloActual = Entero_Cero) THEN

			SET Var_CicloActual := (	SELECT COUNT(CreditoID)
								FROM CREDITOS
								WHERE ClienteID = Var_Cliente
								    AND Estatus IN (Cre_StaPagado, Cre_StaVigente, Cre_StaVencido) );
			# Oscar MAcias Solicito que cuando se calcule el ciclo siempre se debe sumar un 1
			SET	Var_CicloActual	:= IFNULL(Var_CicloActual , Entero_Cero) + 1;
		END IF;

-- ============== FIN SECCION PARA OBTENER EL CICLO ============== --

	ELSE    # Si el producto si es grupal el ciclo se determina por el grupo
		SELECT Gru.GrupoID,	Gru.CicloActual
		INTO Var_NumGrupo,	Var_CicloActual
		FROM INTEGRAGRUPOSCRE Inte
		INNER JOIN GRUPOSCREDITO Gru ON Inte.GrupoID = Gru.GrupoID
		WHERE Inte.SolicitudCreditoID = Par_Solicitud;

		# Monto solicitado de todas las solicitudes que integran el grupo
		SET Var_MontoMaximo :=(SELECT SUM(Sol.MontoSolici)
							FROM INTEGRAGRUPOSCRE Inte
							INNER JOIN SOLICITUDCREDITO Sol ON Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
							WHERE Inte.GrupoID = Var_NumGrupo
							    AND Sol.Estatus IN (Sol_StaAutorizada, Sol_StaLiberada, Sol_StaCancelada) );

		SET	Var_MontoMaximo	:= IFNULL(Var_MontoMaximo, Entero_Cero);
	END IF;

	SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

	IF Var_MontoSolicitado <= Entero_Cero OR  Var_CicloActual = Entero_Cero THEN
		LEAVE	TerminaStore;
	END IF;

	# Se obtiene el Esquema para Solicitudes de REESTRUCTURA Y RENOVACION para el cliente YANGA
	IF (Var_CliProEsp = NumClienteYanga AND Var_TipoCredito IN(CreReestructura,CreRenovacion)) THEN
		SET Var_EsquemaID := (SELECT MAX(EsquemaID) FROM ESQUEMAAUTORIZA WHERE ProducCreditoID = Par_Producto);
			SELECT  Fir.EsquemaID,		Fir.NumFirma,		Fir.OrganoID,		Org.Descripcion
				FROM ESQUEMAAUTORIZA Esq
				INNER JOIN ORGANOAUTORIZA Fir ON Esq.EsquemaID = Fir.EsquemaID
				INNER JOIN ORGANODESICION Org ON Fir.OrganoID = Org.OrganoID
				WHERE Esq.ProducCreditoID = Par_Producto
				AND Esq.EsquemaID = Var_EsquemaID
			ORDER BY Fir.NumFirma, Fir.OrganoID;

    ELSE  # Se obtiene el Esquema para solicitudes Nuevas
		SELECT  Fir.EsquemaID,		Fir.NumFirma,		Fir.OrganoID,		Org.Descripcion
		FROM ESQUEMAAUTORIZA Esq
		INNER JOIN ORGANOAUTORIZA Fir ON Esq.EsquemaID = Fir.EsquemaID
		INNER JOIN ORGANODESICION Org ON Fir.OrganoID = Org.OrganoID
		WHERE   Esq.ProducCreditoID = Par_Producto
			AND   Var_CicloActual >= Esq.CicloInicial
			AND   Var_CicloActual <= Esq.CicloFinal
			AND   Var_MontoSolicitado  >= Esq.MontoInicial
			AND   Var_MontoSolicitado  <= Esq.MontoFinal
			AND   Var_MontoMaximo <= Esq.MontoMaximo
		ORDER BY Esq.CicloInicial, Esq.CicloFinal,  Esq.MontoInicial, Esq.MontoFinal,   Esq.MontoMaximo, Fir.NumFirma, Fir.OrganoID;
	END IF;
END IF;


# 6.- Lista las firmas  filtrando por id de esquema de firma , producto de credito y usuario
IF (Par_NumLis = Lis_PorProdUsuFirma) THEN
	SELECT  Fir.EsquemaID,		Fir.NumFirma,		Fir.OrganoID,		Org.Descripcion
		FROM ESQUEMAAUTORIZA Esq
		INNER JOIN ORGANOAUTORIZA Fir ON Esq.EsquemaID = Fir.EsquemaID
		INNER JOIN ORGANODESICION Org ON Fir.OrganoID = Org.OrganoID
	WHERE   Esq.ProducCreditoID = Par_Producto
		AND Fir.EsquemaID = Par_Esquema
	   AND   Fir.OrganoID IN (	SELECT Org.OrganoID   -- organos en los que se encuentra el usuario y que puede autorizar
						FROM USUARIOS Usu
						INNER JOIN ORGANOINTEGRA Org ON Usu.ClavePuestoID = Org.ClavePuestoID
						WHERE UsuarioID = Aud_Usuario)
	ORDER BY Esq.CicloInicial, Esq.CicloFinal,
		Esq.MontoInicial, Esq.MontoFinal,
		Esq.MontoMaximo, Fir.NumFirma, Fir.OrganoID;
END IF;

END TerminaStore$$