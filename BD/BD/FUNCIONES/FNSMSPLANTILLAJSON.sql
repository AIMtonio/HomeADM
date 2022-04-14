-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNSMSPLANTILLAJSON
DELIMITER ;
DROP FUNCTION IF EXISTS `FNSMSPLANTILLAJSON`;
DELIMITER $$

CREATE FUNCTION `FNSMSPLANTILLAJSON`(
# =====================================================================================
#	FUNCION PARA FORMAR LOS MENSAJES CON BASE A LA PLANTILLA CON LOS VALORES DE UN JSON
# =====================================================================================
	Par_Valores			VARCHAR(400),
	Par_Mensaje			VARCHAR(400),
	Par_NumCon			TINYINT UNSIGNED

) RETURNS VARCHAR(1000)
	DETERMINISTIC
BEGIN


	-- Declaracion de Variables
	DECLARE NoEncontrado			INT;
	DECLARE Var_Valor				VARCHAR(200);
	DECLARE Var_Nombre				VARCHAR(100);
	DECLARE Var_Credito				BIGINT(12);
	DECLARE Var_NombreSucursal		VARCHAR(50);
	DECLARE Var_Cuenta				BIGINT(12);
	DECLARE Var_SolicitudCredito	BIGINT(20);
	DECLARE Var_MontoCredito		DECIMAL(12,2);
	DECLARE Var_TotAdeudo			VARCHAR(30);
	DECLARE Var_MontoExigible		VARCHAR(30);
	DECLARE Var_FechaExigible		VARCHAR(30);
    DECLARE Var_SaldoCapital		VARCHAR(30);
	DECLARE Var_DiasAtraso			INT;

	-- Declaracion de constantes
	DECLARE Cadena_Vacia            CHAR(1);
	DECLARE Entero_Cero             INT(11);
	DECLARE Fecha_Vacia         	DATE;
	DECLARE Con_Decimal         	DECIMAL;


	-- Asignacion de constantes
	SET Cadena_Vacia        		:= '';
	SET Entero_Cero         		:= 0;
	SET Fecha_Vacia         		:= '1900-01-01';
	SET Con_Decimal         		:= 0.00;


	SET NoEncontrado        		:= 0;



    # =====================================================================================
	#	Parte 1: Crea El Nombre del Cliente
    # =====================================================================================
	IF(Par_Mensaje LIKE  '%&CL%'  ) THEN
		SET Var_Valor := FNSMSEXTRAERJSONVALOR('ClienteId',Par_Valores);

		SELECT 	CONCAT(IFNULL(PrimerNombre,Cadena_Vacia),' ',IFNULL(SegundoNombre,Cadena_Vacia),' ',IFNULL(TercerNombre,Cadena_Vacia),' ',IFNULL(ApellidoPaterno,Cadena_Vacia),' ',
				IFNULL(ApellidoMaterno,Cadena_Vacia))
				INTO Var_Nombre
			FROM CLIENTES
			WHERE ClienteID = Var_Valor;

		IF(IFNULL(Var_Nombre,Cadena_Vacia) =  Cadena_Vacia) THEN
			SET Par_Mensaje := REPLACE(Par_Mensaje,'&CL','CLIENTE');
			SET NoEncontrado:= NoEncontrado + 1;
		ELSE

			SET Par_Mensaje := REPLACE(Par_Mensaje,'&CL',Var_Nombre);
		END IF;
	ELSE
		SET Par_Mensaje := REPLACE(Par_Mensaje,'&CL','CLIENTE');
	END IF;



	# =====================================================================================
	#	Parte 2: Crea la Informacion de la Sucursal del Cliente
	# =====================================================================================
	IF(Par_Mensaje LIKE '%&SU%') THEN
		SET Var_Valor := FNSMSEXTRAERJSONVALOR('ClienteId',Par_Valores);

		SELECT  S.NombreSucurs INTO Var_NombreSucursal
			FROM CLIENTES C INNER JOIN SUCURSALES S ON C.SucursalOrigen	= S.SucursalID
			WHERE	C.ClienteID = Var_Valor;

		IF(IFNULL(Var_NombreSucursal,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_Mensaje := (REPLACE(Par_Mensaje,'&SU','SUCURSAL'));
			SET NoEncontrado:= NoEncontrado + 1;
		ELSE
			SET Par_Mensaje  :=(REPLACE(Par_Mensaje,'&SU',Var_NombreSucursal));
		END IF;
	ELSE
		SET Par_Mensaje := (REPLACE(Par_Mensaje,'&SU','SUCURSAL'));
	END IF;

	# =====================================================================================
	#	Parte 3: Crea la Informacion de la Cuenta Destino
	# =====================================================================================
	IF(Par_Mensaje LIKE '%&CD%') THEN
		SET Var_Valor := FNSMSEXTRAERJSONVALOR('CuentaDestinoID',Par_Valores);

		IF(IFNULL(Var_Valor,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_Mensaje := (REPLACE(Par_Mensaje,'&CD','CUENTADESTINO'));
			SET NoEncontrado:= NoEncontrado + 1;
		ELSE
			SET Par_Mensaje  :=(REPLACE(Par_Mensaje,'&CD',Var_Valor));
		END IF;
	ELSE
		SET Par_Mensaje := (REPLACE(Par_Mensaje,'&CD','CUENTADESTINO'));
	END IF;

	# =====================================================================================
	#	Parte 3.1: Crea la Informacion de la Cuenta Destino Ultimos 4 digitos
	# =====================================================================================
	IF(Par_Mensaje LIKE '%&U4CD%') THEN
		SET Var_Valor := FNSMSEXTRAERJSONVALOR('CuentaDestinoID',Par_Valores);

		IF(IFNULL(Var_Valor,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_Mensaje := (REPLACE(Par_Mensaje,'&U4CD','CUENTADESTINO'));
			SET NoEncontrado:= NoEncontrado + 1;
		ELSE
			SET Var_Valor 	:= RIGHT(CONCAT("0000",Var_Valor),4);
			SET Par_Mensaje	:=(REPLACE(Par_Mensaje,'&U4CD',Var_Valor));
		END IF;
	ELSE
		SET Par_Mensaje := (REPLACE(Par_Mensaje,'&U4CD','CUENTADESTINO'));
	END IF;

	# =====================================================================================
	#	Parte 4: Crea la Informacion de la Cuenta Origen
	# =====================================================================================
	IF(Par_Mensaje LIKE '%&CO%') THEN
		SET Var_Valor := FNSMSEXTRAERJSONVALOR('CuentaOrigenID',Par_Valores);

		IF(IFNULL(Var_Valor,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_Mensaje := (REPLACE(Par_Mensaje,'&CO','CUENTAORIGEN'));
			SET NoEncontrado:= NoEncontrado + 1;
		ELSE
			SET Par_Mensaje  :=(REPLACE(Par_Mensaje,'&CO',Var_Valor));
		END IF;
	ELSE
		SET Par_Mensaje := (REPLACE(Par_Mensaje,'&CO','CUENTAORIGEN'));
	END IF;

	# =====================================================================================
	#	Parte 4.1: Crea la Informacion de la Cuenta Origen Ultimos 4 digitos
	# =====================================================================================
	IF(Par_Mensaje LIKE '%&U4CO%') THEN
		SET Var_Valor := FNSMSEXTRAERJSONVALOR('CuentaOrigenID',Par_Valores);

		IF(IFNULL(Var_Valor,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_Mensaje := (REPLACE(Par_Mensaje,'&U4CO','CUENTAORIGEN'));
			SET NoEncontrado:= NoEncontrado + 1;
		ELSE
			SET Var_Valor 	:= RIGHT(CONCAT("0000",Var_Valor),4);
			SET Par_Mensaje	:=(REPLACE(Par_Mensaje,'&U4CO',Var_Valor));
		END IF;
	ELSE
		SET Par_Mensaje := (REPLACE(Par_Mensaje,'&U4CO','CUENTAORIGEN'));
	END IF;


	# =====================================================================================
	#	Parte 5: Crea la Informacion del Monto Total
	# =====================================================================================
	IF(Par_Mensaje LIKE '%&MT%') THEN
		SET Var_Valor := FNSMSEXTRAERJSONVALOR('MontoTotal',Par_Valores);

		IF(IFNULL(Var_Valor,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_Mensaje := (REPLACE(Par_Mensaje,'&MT','MONTOTOTAL'));
			SET NoEncontrado:= NoEncontrado + 1;
		ELSE
			SET Var_Valor 	:= CONCAT('$',Var_Valor);
			SET Par_Mensaje  :=(REPLACE(Par_Mensaje,'&MT',Var_Valor));
		END IF;
	ELSE
		SET Par_Mensaje := (REPLACE(Par_Mensaje,'&MT','MONTOTOTAL'));
	END IF;


	# =====================================================================================
	#	Parte 6: Crea la Informacion del Numero de Transaccion
	# =====================================================================================
	IF(Par_Mensaje LIKE '%&NT%') THEN
		SET Var_Valor := FNSMSEXTRAERJSONVALOR('NumTransaccion',Par_Valores);

		IF(IFNULL(Var_Valor,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_Mensaje := (REPLACE(Par_Mensaje,'&NT','NUMTRANSACCION'));
			SET NoEncontrado:= NoEncontrado + 1;
		ELSE
			SET Par_Mensaje  :=(REPLACE(Par_Mensaje,'&NT',Var_Valor));
		END IF;
	ELSE
		SET Par_Mensaje := (REPLACE(Par_Mensaje,'&NT','NUMTRANSACCION'));
	END IF;


	# =====================================================================================
	#	Parte 7: Crea la Informacion de la Fecha Actual de la Transaccion
	# =====================================================================================
	IF(Par_Mensaje LIKE '%&FA%') THEN
		SET Var_Valor := FNSMSEXTRAERJSONVALOR('FechaActual',Par_Valores);

		IF(IFNULL(Var_Valor,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_Mensaje := (REPLACE(Par_Mensaje,'&FA',DATE_FORMAT(NOW(),'%Y/%m/%d')));
			SET NoEncontrado:= NoEncontrado + 1;
		ELSE
			SET Var_Valor	:= DATE_FORMAT(Var_Valor,'%Y/%m/%d');
			SET Par_Mensaje	:=(REPLACE(Par_Mensaje,'&FA',Var_Valor));
		END IF;
	ELSE
		SET Par_Mensaje := (REPLACE(Par_Mensaje,'&FA','FECHAACTUAL'));
	END IF;


	# =====================================================================================
	#	Parte 8: Crea la Informacion de la Clave de Rastreo
	# =====================================================================================
	IF(Par_Mensaje LIKE '%&RA%') THEN
		SET Var_Valor := FNSMSEXTRAERJSONVALOR('ClaveRastreo',Par_Valores);

		IF(IFNULL(Var_Valor,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_Mensaje := (REPLACE(Par_Mensaje,'&RA','CLAVERASTREO'));
			SET NoEncontrado:= NoEncontrado + 1;
		ELSE
			SET Par_Mensaje	:=(REPLACE(Par_Mensaje,'&RA',Var_Valor));
		END IF;
	ELSE
		SET Par_Mensaje := (REPLACE(Par_Mensaje,'&RA','CLAVERASTREO'));
	END IF;

	# =====================================================================================
	#	Parte 8: Crea la Informacion de Servicio
	# =====================================================================================
	IF(Par_Mensaje LIKE '%&SV%') THEN
		SET Var_Valor := FNSMSEXTRAERJSONVALOR('DescServicio',Par_Valores);

		IF(IFNULL(Var_Valor,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_Mensaje := (REPLACE(Par_Mensaje,'&SV','SERVICIO'));
			SET NoEncontrado:= NoEncontrado + 1;
		ELSE
			SET Par_Mensaje	:=(REPLACE(Par_Mensaje,'&SV',SUBSTRING(Var_Valor,1,30)));
		END IF;
	ELSE
		SET Par_Mensaje := (REPLACE(Par_Mensaje,'&SV','SERVICIO'));
	END IF;

	SET Par_Mensaje = IFNULL(Par_Mensaje, Cadena_Vacia);

	RETURN Par_Mensaje;
END$$