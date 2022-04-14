package seguimiento.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;
import java.util.StringTokenizer;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import seguimiento.bean.RepEficaciaSeguimientoBean;
import seguimiento.bean.RepSeguimientoBean;
import seguimiento.bean.SeguimientoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class SeguimientoDAO extends BaseDAO{

	public SeguimientoDAO(){
		super();
	}

	public MensajeTransaccionBean altaDefinicionSeguimiento(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				String seguimientoID;
				try {
					// alta de seguimiento
					mensajeBean = altaSeguimiento(seguimientoBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					seguimientoID = mensajeBean.getConsecutivoString();
					seguimientoBean.setSeguimientoID(seguimientoID);
					int i=0;
					if(!seguimientoBean.getLisPlazas().isEmpty()){
						StringTokenizer tokensPlazas = new StringTokenizer(seguimientoBean.getLisPlazas(), ",");
						String lisPlaza[] = new String[tokensPlazas.countTokens()];

						while(tokensPlazas.hasMoreTokens()){
							lisPlaza[i] = String.valueOf(tokensPlazas.nextToken());
							i++;
						}
						for(int contador=0; contador < lisPlaza.length; contador++){
							seguimientoBean.setPlazaID(String.valueOf(lisPlaza[contador]));
							// alta alcance de plaza
							mensajeBean = altaAlcancePlaza(seguimientoBean);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}

					if(!seguimientoBean.getLisSucursal().isEmpty()){
						StringTokenizer tokensSucursal = new StringTokenizer(seguimientoBean.getLisSucursal(), ",");
						String lisSucur[] = new String[tokensSucursal.countTokens()];
						i=0;
						while(tokensSucursal.hasMoreTokens()){
							lisSucur[i] = String.valueOf(tokensSucursal.nextToken());
							i++;
						}
						for(int contador=0; contador < lisSucur.length; contador++){
							seguimientoBean.setSucursalID(String.valueOf(lisSucur[contador]));
							// alta alcance de sucursal
							mensajeBean = altaAlcanceSucursal(seguimientoBean);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}

					if(!seguimientoBean.getLisEjecutivo().isEmpty()){
						StringTokenizer tokensEjecutivo = new StringTokenizer(seguimientoBean.getLisEjecutivo(), ",");
						String lisEjecu[] = new String[tokensEjecutivo.countTokens()];
						i=0;
						while(tokensEjecutivo.hasMoreTokens()){
							lisEjecu[i] = String.valueOf(tokensEjecutivo.nextToken());
							i++;
						}
						for(int contador=0; contador < lisEjecu.length; contador++){
							seguimientoBean.setEjecutivoID(String.valueOf(lisEjecu[contador]));
							// alta alcance de ejecutivo
							mensajeBean = altaAlcanceEjecutivo(seguimientoBean);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}

					if(!seguimientoBean.getLisFondeo().isEmpty()){
						StringTokenizer tokensFondeo = new StringTokenizer(seguimientoBean.getLisFondeo(), ",");
						String lisFondeo[] = new String[tokensFondeo.countTokens()];
						i=0;
						while(tokensFondeo.hasMoreTokens()){
							lisFondeo[i] = String.valueOf(tokensFondeo.nextToken());
							i++;
						}
						for(int contador=0; contador < lisFondeo.length; contador++){
							seguimientoBean.setFondeadorID(String.valueOf(lisFondeo[contador]));
							// alta alcance de fondeador
							mensajeBean = altaFondeador(seguimientoBean);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}

					for(i=0; i<seguimientoBean.getProductosID().size(); i++){
						seguimientoBean.setProductoID((String) seguimientoBean.getProductosID().get(i));
						// alta de productos
						mensajeBean = altaProductos(seguimientoBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					for(i=0; i<seguimientoBean.getSelecCompuerta().size(); i++){
						seguimientoBean.setCompuerta((String) seguimientoBean.getSelecCompuerta().get(i));
						seguimientoBean.setCondici1((String) seguimientoBean.getSelecCondi1().get(i));
						seguimientoBean.setOperador((String) seguimientoBean.getSelecOperador().get(i));
						seguimientoBean.setCondici2((String) seguimientoBean.getSelecCondi2().get(i));
						if ( (String) seguimientoBean.getCondiciOpc().get(i) != "") {
							seguimientoBean.setConOpc((String) seguimientoBean.getCondiciOpc().get(i));
						}else{
							seguimientoBean.setConOpc(Constantes.STRING_CERO);
						}
						// alta de condiciones
						mensajeBean = altaCondiciones(seguimientoBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					for(i=0; i<seguimientoBean.getClasifCondicion().size(); i++){
						seguimientoBean.setClaCondicion((String) seguimientoBean.getClasifCondicion().get(i));
						seguimientoBean.setClaOperador((String) seguimientoBean.getClasifOperador().get(i));

						// alta de clasificacion
						mensajeBean = altaClasificacion(seguimientoBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					for(i=0; i<seguimientoBean.getComboCriterio().size(); i++){
						seguimientoBean.setPeriodicidad((String) seguimientoBean.getPrograPeriodicidad().get(i));
						seguimientoBean.setAvanceCredito((String) seguimientoBean.getPrograAvanceCredito().get(i));
						seguimientoBean.setDiasOtorga((String) seguimientoBean.getPrograDiasOtorga().get(i));
						seguimientoBean.setDiasAntLiq((String) seguimientoBean.getPrograDiasAntLiq().get(i));
						seguimientoBean.setDiasAntCuota((String) seguimientoBean.getPrograDiasAntCuota().get(i));
						seguimientoBean.setMaxUltSegto((String) seguimientoBean.getPrograMaxUltSegto().get(i));
						seguimientoBean.setMinUltSegto((String) seguimientoBean.getPrograMinUltSegto().get(i));
						seguimientoBean.setPlazoMaximo((String) seguimientoBean.getPrograPlazoMaximo().get(i));
						seguimientoBean.setDiaMes((String) seguimientoBean.getPrograDiaMes().get(i));
						seguimientoBean.setDiaSemana((String) seguimientoBean.getPrograDiaSemana().get(i));
						seguimientoBean.setDiaHabil((String) seguimientoBean.getPrograDiaHabil().get(i));
						//alta de programacion de seguimiento
						mensajeBean = altaProgramacionSegto(seguimientoBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Seguimiento Agregado Exitosamente: "+seguimientoBean.getSeguimientoID());
					mensajeBean.setNombreControl("seguimientoID");
					mensajeBean.setConsecutivoString(seguimientoBean.getSeguimientoID());
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de seguimiendo de campo", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificaSeguimiento(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// modifica seguimiento
					mensajeBean = modificaSegto(seguimientoBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					mensajeBean = eliminaAlcancePlazas(seguimientoBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					int i=0;
					if(!seguimientoBean.getLisPlazas().isEmpty()){
						StringTokenizer tokensPlazas = new StringTokenizer(seguimientoBean.getLisPlazas(), ",");
						String lisPlaza[] = new String[tokensPlazas.countTokens()];

						while(tokensPlazas.hasMoreTokens()){
							lisPlaza[i] = String.valueOf(tokensPlazas.nextToken());
							i++;
						}
						for(int contador=0; contador < lisPlaza.length; contador++){
							seguimientoBean.setPlazaID(String.valueOf(lisPlaza[contador]));
							mensajeBean = altaAlcancePlaza(seguimientoBean);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}

					mensajeBean = eliminaAlcanceSucursal(seguimientoBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					if(!seguimientoBean.getLisSucursal().isEmpty()){
						StringTokenizer tokensSucursal = new StringTokenizer(seguimientoBean.getLisSucursal(), ",");
						String lisSucur[] = new String[tokensSucursal.countTokens()];
						i=0;
						while(tokensSucursal.hasMoreTokens()){
							lisSucur[i] = String.valueOf(tokensSucursal.nextToken());
							i++;
						}
						for(int contador=0; contador < lisSucur.length; contador++){
							seguimientoBean.setSucursalID(String.valueOf(lisSucur[contador]));
							mensajeBean = altaAlcanceSucursal(seguimientoBean);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}

					mensajeBean = eliminaAlcanceEjecutivo(seguimientoBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					if(!seguimientoBean.getLisEjecutivo().isEmpty()){
						StringTokenizer tokensEjecutivo = new StringTokenizer(seguimientoBean.getLisEjecutivo(), ",");
						String lisEjecu[] = new String[tokensEjecutivo.countTokens()];
						i=0;
						while(tokensEjecutivo.hasMoreTokens()){
							lisEjecu[i] = String.valueOf(tokensEjecutivo.nextToken());
							i++;
						}
						for(int contador=0; contador < lisEjecu.length; contador++){
							seguimientoBean.setEjecutivoID(String.valueOf(lisEjecu[contador]));
							mensajeBean = altaAlcanceEjecutivo(seguimientoBean);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}
					mensajeBean = eliminaFondeador(seguimientoBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					if(!seguimientoBean.getLisFondeo().isEmpty()){
						StringTokenizer tokensFondeo = new StringTokenizer(seguimientoBean.getLisFondeo(), ",");
						String lisFondeo[] = new String[tokensFondeo.countTokens()];
						i=0;
						while(tokensFondeo.hasMoreTokens()){
							lisFondeo[i] = String.valueOf(tokensFondeo.nextToken());
							i++;
						}
						for(int contador=0; contador < lisFondeo.length; contador++){
							seguimientoBean.setFondeadorID(String.valueOf(lisFondeo[contador]));
							mensajeBean = altaFondeador(seguimientoBean);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}

					mensajeBean = eliminaProductos(seguimientoBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					for( i=0; i<seguimientoBean.getProductosID().size(); i++){
						seguimientoBean.setProductoID((String) seguimientoBean.getProductosID().get(i));
						mensajeBean = altaProductos(seguimientoBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					mensajeBean = eliminaCondiciones(seguimientoBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					for( i=0; i<seguimientoBean.getSelecCompuerta().size(); i++){
						seguimientoBean.setCompuerta((String) seguimientoBean.getSelecCompuerta().get(i));
						seguimientoBean.setCondici1((String) seguimientoBean.getSelecCondi1().get(i));
						seguimientoBean.setOperador((String) seguimientoBean.getSelecOperador().get(i));
						seguimientoBean.setCondici2((String) seguimientoBean.getSelecCondi2().get(i));
						if ( (String) seguimientoBean.getCondiciOpc().get(i) != "") {
							seguimientoBean.setConOpc((String) seguimientoBean.getCondiciOpc().get(i));
						}else{
							seguimientoBean.setConOpc(Constantes.STRING_CERO);
						}
						mensajeBean = altaCondiciones(seguimientoBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = eliminaClasificacion(seguimientoBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					for( i=0; i<seguimientoBean.getClasifCondicion().size(); i++){
						seguimientoBean.setClaCondicion((String) seguimientoBean.getClasifCondicion().get(i));
						seguimientoBean.setClaOperador((String) seguimientoBean.getClasifOperador().get(i));

						mensajeBean = altaClasificacion(seguimientoBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					mensajeBean = eliminaProgramacion(seguimientoBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					for( i=0; i<seguimientoBean.getComboCriterio().size(); i++){
						seguimientoBean.setPeriodicidad((String) seguimientoBean.getPrograPeriodicidad().get(i));
						seguimientoBean.setAvanceCredito((String) seguimientoBean.getPrograAvanceCredito().get(i));
						seguimientoBean.setDiasOtorga((String) seguimientoBean.getPrograDiasOtorga().get(i));
						seguimientoBean.setDiasAntLiq((String) seguimientoBean.getPrograDiasAntLiq().get(i));
						seguimientoBean.setDiasAntCuota((String) seguimientoBean.getPrograDiasAntCuota().get(i));
						seguimientoBean.setMaxUltSegto((String) seguimientoBean.getPrograMaxUltSegto().get(i));
						seguimientoBean.setMinUltSegto((String) seguimientoBean.getPrograMinUltSegto().get(i));
						seguimientoBean.setPlazoMaximo((String) seguimientoBean.getPrograPlazoMaximo().get(i));
						seguimientoBean.setDiaMes((String) seguimientoBean.getPrograDiaMes().get(i));
						seguimientoBean.setDiaSemana((String) seguimientoBean.getPrograDiaSemana().get(i));
						seguimientoBean.setDiaHabil((String) seguimientoBean.getPrograDiaHabil().get(i));
						mensajeBean = altaProgramacionSegto(seguimientoBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					mensajeBean.setNumero(0);
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Seguimiento Modificado Exitosamente: "+seguimientoBean.getSeguimientoID());
					mensajeBean.setNombreControl("seguimientoID");
					mensajeBean.setConsecutivoString(seguimientoBean.getSeguimientoID());
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificación de seguimiendo de campo", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean eliminaAlcanceEjecutivo(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SEGTOXEJECUTIVOBAJ(?,?, ?,?,?,?,?,?,?);";
					Object[] parametros = {
							seguimientoBean.getSeguimientoID(),
							Constantes.ENTERO_CERO,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"LineasCreditoDAO.baja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOXEJECUTIVOBAJ(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de segto por programacion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean eliminaFondeador(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SEGTOFONDEOBAJ(?,?, ?,?,?,?,?,?,?);";
					Object[] parametros = {
							seguimientoBean.getSeguimientoID(),
							Constantes.ENTERO_CERO,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"LineasCreditoDAO.baja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOFONDEOBAJ(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de segto por programacion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public MensajeTransaccionBean eliminaAlcanceSucursal(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SEGTOXSUCURSALBAJ(?,?, ?,?,?,?,?,?,?);";
					Object[] parametros = {
							seguimientoBean.getSeguimientoID(),
							Constantes.ENTERO_CERO,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"LineasCreditoDAO.baja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOXSUCURSALBAJ(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de segto por programacion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public MensajeTransaccionBean eliminaAlcancePlazas(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SEGTOXPLAZASBAJ(?,?, ?,?,?,?,?,?,?);";
					Object[] parametros = {
							seguimientoBean.getSeguimientoID(),
							Constantes.ENTERO_CERO,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"LineasCreditoDAO.baja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
						};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOXPLAZASBAJ(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de segto por programacion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public MensajeTransaccionBean altaFondeador(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SEGTOFONDEOALT(" +
										"?,?,?,?,?," +
										"?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_SeguimientoID",seguimientoBean.getSeguimientoID());
									sentenciaStore.setString("Par_FondeadorID",seguimientoBean.getFondeadorID());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SeguimientoDAO.productos");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .ClientesDAO.altaCliente");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cliente" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}



	public MensajeTransaccionBean altaAlcanceEjecutivo(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SEGTOALCANCEJECALT(" +
										"?,?,?,?,?," +
										"?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_SeguimientoID",seguimientoBean.getSeguimientoID());
									sentenciaStore.setString("Par_EjecutivoID",seguimientoBean.getEjecutivoID());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SeguimientoDAO.productos");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .ClientesDAO.altaCliente");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cliente" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	public MensajeTransaccionBean altaAlcanceSucursal(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SEGTOALCANCESUCALT(" +
										"?,?,?,?,?," +
										"?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_SeguimientoID",seguimientoBean.getSeguimientoID());
									sentenciaStore.setString("Par_SucursalID",seguimientoBean.getSucursalID());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SeguimientoDAO.productos");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .SeguimientoDAO.altaAlcanceSucursal");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de alcance de sucursal" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


	public MensajeTransaccionBean altaAlcancePlaza(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SEGTOALCANCEPLAALT(" +
										"?,?,?,?,?," +
										"?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_SeguimientoID",seguimientoBean.getSeguimientoID());
									sentenciaStore.setString("Par_PlazaID",seguimientoBean.getPlazaID());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SeguimientoDAO.altaAlcancePlaza");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .SeguimientoDAO.altaAlcancePlaza");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de alcance de plaza" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


	public MensajeTransaccionBean eliminaProgramacion(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SEGTOPROGRAMABAJ(?,?, ?,?,?,?,?,?,?);";
					Object[] parametros = {
							seguimientoBean.getSeguimientoID(),
							Constantes.ENTERO_CERO,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"LineasCreditoDAO.baja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOPROGRAMABAJ(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de segto por programacion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean eliminaClasificacion(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SEGTOCLASIFICBAJ(?,? ,?,?,?,?,?,?,?);";
					Object[] parametros = {
							seguimientoBean.getSeguimientoID(),
							Constantes.ENTERO_CERO,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"LineasCreditoDAO.baja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOCLASIFICBAJ(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de segto por clasificacion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean eliminaCondiciones(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SEGTOCRITERIOSBAJ(?,?, ?,?,?,?,?,?,?);";
					Object[] parametros = {
							seguimientoBean.getSeguimientoID(),
							Constantes.ENTERO_CERO,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"LineasCreditoDAO.baja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOCRITERIOSBAJ(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de segto por criterios", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean eliminaProductos(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SEGTOPRODUCTOBAJ(?,? ,?,?,?,?,?,?,?);";
					Object[] parametros = {
							seguimientoBean.getSeguimientoID(),
							Constantes.ENTERO_CERO,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"LineasCreditoDAO.baja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOPRODUCTOBAJ(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de segto por productos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificaSegto(final SeguimientoBean seguimientoBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SEGUIMIENTOCAMPOMOD(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?,	?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_SeguimientoID",Utileria.convierteEntero(seguimientoBean.getSeguimientoID()));
									sentenciaStore.setString("Par_Descripcion",seguimientoBean.getDescripcion());
									sentenciaStore.setString("Par_CategoriaID",seguimientoBean.getCategoriaID());
									sentenciaStore.setString("Par_CicloCteInicio",seguimientoBean.getCicloCteInicio());
									sentenciaStore.setString("Par_CicloCteFin",seguimientoBean.getCicloCteFinal());

									sentenciaStore.setString("Par_Estatus",seguimientoBean.getEstatus());
									sentenciaStore.setInt("Par_EjecutorID",Utileria.convierteEntero(seguimientoBean.getEjecutorID()));
									sentenciaStore.setString("Par_NivelAplicacion",seguimientoBean.getNivelAplicacion());
									sentenciaStore.setString("Par_AplicaCarteraVig",seguimientoBean.getAplicaCarteraVig());
									sentenciaStore.setString("Par_AplicaCarteraAtra",seguimientoBean.getAplicaCarteraAtra());

									sentenciaStore.setString("Par_AplicaCarteraVen",seguimientoBean.getAplicaCarteraVen());
									sentenciaStore.setString("Par_NoAplicaCartera",seguimientoBean.getCarteraNoAplica());
									sentenciaStore.setString("Par_PermiteManual",seguimientoBean.getPermiteManual());
									sentenciaStore.setString("Par_Base",seguimientoBean.getBase());
									sentenciaStore.setInt("Par_BasePorcen",(seguimientoBean.getBasePorcentaje() != Constantes.STRING_VACIO ? Utileria.convierteEntero(seguimientoBean.getBasePorcentaje()) : Constantes.ENTERO_CERO));

									sentenciaStore.setInt("Par_BaseNumero",(seguimientoBean.getBaseNumero() != Constantes.STRING_VACIO ? Utileria.convierteEntero(seguimientoBean.getBaseNumero()) : Constantes.ENTERO_CERO));
									sentenciaStore.setString("Par_Alcance",seguimientoBean.getAlcance());
									sentenciaStore.setString("Par_RecPropios", (seguimientoBean.getRecPropios() != null ? Constantes.STRING_SI : Constantes.STRING_NO));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SeguimientoDAO.modificaSegto");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .SeguimientoDAO.modificaSegto");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la modificacion de seguimiento" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
	}


	public MensajeTransaccionBean altaClasificacion(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SEGTOCLASIFICALT(" +
										"?,?,?,?,?,?," +
										"?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_SeguimientoID",seguimientoBean.getSeguimientoID());
									sentenciaStore.setString("Par_CondiClasif",seguimientoBean.getClaCondicion());
									sentenciaStore.setString("Par_OrdenClasif",seguimientoBean.getClaOperador());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SeguimientoDAO.productos");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .ClientesDAO.altaCliente");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cliente" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


	public MensajeTransaccionBean altaProductos(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SEGTOPRODUCTOALT(" +
										"?,?,?,?,?," +
										"?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_SeguimientoID",seguimientoBean.getSeguimientoID());
									sentenciaStore.setString("Par_ProductoID",seguimientoBean.getProductoID());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SeguimientoDAO.productos");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .ClientesDAO.altaCliente");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cliente" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	/* Alta del Cliente */
	public MensajeTransaccionBean altaSeguimiento(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SEGUIMIENTOCAMPOALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?,	?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_Descripcion",seguimientoBean.getDescripcion());
									sentenciaStore.setString("Par_CategoriaID",seguimientoBean.getCategoriaID());
									sentenciaStore.setString("Par_CicloCteInicio",seguimientoBean.getCicloCteInicio());
									sentenciaStore.setString("Par_CicloCteFin",seguimientoBean.getCicloCteFinal());
									sentenciaStore.setString("Par_Estatus",seguimientoBean.getEstatus());

									sentenciaStore.setInt("Par_EjecutorID",Utileria.convierteEntero(seguimientoBean.getEjecutorID()));
									sentenciaStore.setString("Par_NivelAplicacion",seguimientoBean.getNivelAplicacion());
									sentenciaStore.setString("Par_AplicaCarteraVig",seguimientoBean.getAplicaCarteraVig());
									sentenciaStore.setString("Par_AplicaCarteraAtra",seguimientoBean.getAplicaCarteraAtra());

									sentenciaStore.setString("Par_AplicaCarteraVen",seguimientoBean.getAplicaCarteraVen());
									sentenciaStore.setString("Par_NoAplicaCartera",seguimientoBean.getCarteraNoAplica());
									sentenciaStore.setString("Par_PermiteManual",seguimientoBean.getPermiteManual());
									sentenciaStore.setString("Par_Base",seguimientoBean.getBase());
									sentenciaStore.setInt("Par_BasePorcen",(seguimientoBean.getBasePorcentaje() != Constantes.STRING_VACIO ? Utileria.convierteEntero(seguimientoBean.getBasePorcentaje()) : Constantes.ENTERO_CERO));

									sentenciaStore.setInt("Par_BaseNumero",(seguimientoBean.getBaseNumero() != Constantes.STRING_VACIO ? Utileria.convierteEntero(seguimientoBean.getBaseNumero()) : Constantes.ENTERO_CERO));
									sentenciaStore.setString("Par_Alcance",seguimientoBean.getAlcance());
									sentenciaStore.setString("Par_RecPropios", (seguimientoBean.getRecPropios() != null ? Constantes.STRING_SI : Constantes.STRING_NO));
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClientesDAO.altaCliente");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .ClientesDAO.altaCliente");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cliente" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	/* Alta del Condiciones de Seguimiento de Campo*/
	public MensajeTransaccionBean altaCondiciones(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SEGTOCRITERIOSALT(" +
										"?,?,?,?,?, ?,?,?,?," +
										"?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_SeguimientoID",seguimientoBean.getSeguimientoID());
									sentenciaStore.setString("Par_Compuerta",seguimientoBean.getCompuerta());
									sentenciaStore.setString("Par_Condicion1",seguimientoBean.getCondici1());
									sentenciaStore.setString("Par_Operador",seguimientoBean.getOperador());
									sentenciaStore.setString("Par_Condicion2",seguimientoBean.getCondici2());

									sentenciaStore.setString("Par_ValorOpc",seguimientoBean.getConOpc());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClientesDAO.altaCliente");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .ClientesDAO.altaCliente");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cliente" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	/* Alta del Programacion de Seguimiento de Campo*/
	public MensajeTransaccionBean altaProgramacionSegto(final SeguimientoBean seguimientoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SEGTOPROGRAMAALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?," +
										"?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_SeguimientoID",seguimientoBean.getSeguimientoID());
									sentenciaStore.setString("Par_Periodicidad",seguimientoBean.getPeriodicidad());
									sentenciaStore.setInt("Par_Avance",(seguimientoBean.getAvanceCredito() == Constantes.STRING_VACIO) ? Constantes.ENTERO_CERO : Utileria.convierteEntero(seguimientoBean.getAvanceCredito()));
									sentenciaStore.setInt("Par_DiasPostOtorga",(seguimientoBean.getDiasOtorga() == Constantes.STRING_VACIO ? Constantes.ENTERO_CERO : Utileria.convierteEntero(seguimientoBean.getDiasOtorga())));
									sentenciaStore.setInt("Par_DiasAnteLiquida",(seguimientoBean.getDiasAntLiq() == Constantes.STRING_VACIO ? Constantes.ENTERO_CERO : Utileria.convierteEntero(seguimientoBean.getDiasAntLiq())));

									sentenciaStore.setInt("Par_DiasAntePagCuota",(seguimientoBean.getDiasAntCuota() == Constantes.STRING_VACIO ? Constantes.ENTERO_CERO : Utileria.convierteEntero(seguimientoBean.getDiasAntCuota())));
									sentenciaStore.setInt("Par_PlazoMinUltSegto",(seguimientoBean.getMinUltSegto() == Constantes.STRING_VACIO ? Constantes.ENTERO_CERO : Utileria.convierteEntero(seguimientoBean.getMinUltSegto())));
									sentenciaStore.setInt("Par_PlazoMaxUltSegto",(seguimientoBean.getMaxUltSegto() == Constantes.STRING_VACIO ? Constantes.ENTERO_CERO : Utileria.convierteEntero(seguimientoBean.getMaxUltSegto())));
									sentenciaStore.setInt("Par_PlazoMaxEventos", (seguimientoBean.getPlazoMaximo() == Constantes.STRING_VACIO ? Constantes.ENTERO_CERO : Utileria.convierteEntero(seguimientoBean.getPlazoMaximo())));
									sentenciaStore.setInt("Par_DiaFijoMes", (seguimientoBean.getDiaMes() == Constantes.STRING_VACIO ? Constantes.ENTERO_CERO : Utileria.convierteEntero(seguimientoBean.getDiaMes())));

									sentenciaStore.setString("Par_DiaFijoSem",seguimientoBean.getDiaSemana());
									sentenciaStore.setString("Par_DiaHabil",seguimientoBean.getDiaHabil());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClientesDAO.altaCliente");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .ClientesDAO.altaCliente");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cliente" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	/* Consuta de Seguimiento por Llave Principal*/
	public SeguimientoBean consulta(int tipoConsulta, SeguimientoBean seguimiento) {
		SeguimientoBean seguimientoBean = null;
		try{
		//Query con el Store Procedure
		String query = "call SEGUIMNTOCAMPOCON(?,?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {	seguimiento.getSeguimientoID(),
                				Constantes.ENTERO_CERO,
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SeguimientoDAO.consulta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGUIMNTOCAMPOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							SeguimientoBean segtoBean= new SeguimientoBean();
							segtoBean.setSeguimientoID(resultSet.getString(1));
							segtoBean.setDescripcion(resultSet.getString(2));
							segtoBean.setCategoriaID(resultSet.getString(3));
							segtoBean.setCicloCteInicio(resultSet.getString(4));
							segtoBean.setCicloCteFinal(resultSet.getString(5));
							segtoBean.setEjecutorID(resultSet.getString(6));
							segtoBean.setNivelAplicacion(resultSet.getString(7));
							segtoBean.setAplicaCarteraVig(resultSet.getString(8));
							segtoBean.setAplicaCarteraAtra(resultSet.getString(9));
							segtoBean.setAplicaCarteraVen(resultSet.getString(10));
							segtoBean.setCarteraNoAplica(resultSet.getString(11));
							segtoBean.setPermiteManual(resultSet.getString(12));
							segtoBean.setBase(resultSet.getString(13));
							segtoBean.setBaseNumero(resultSet.getString(14));
							segtoBean.setAlcance(resultSet.getString(15));
							segtoBean.setRecPropios(resultSet.getString(16));
							segtoBean.setEstatus(resultSet.getString(17));

						return segtoBean;
					}
			});
			seguimientoBean = matches.size() > 0 ? (SeguimientoBean) matches.get(0) : null;
		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de seguimientos", e);
		}
		return seguimientoBean;
	}

	/* Consuta de Gestores por Categoria*/
	public SeguimientoBean conGestorCategoria(int tipoConsulta, SeguimientoBean seguimiento) {
		SeguimientoBean seguimientoBean = null;
		try{
			//Query con el Store Procedure
			String query = "call SEGUIMNTOCAMPOCON(?,?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {
								seguimiento.getEjecutorID(),
								seguimiento.getCategoriaID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SeguimientoDAO.conGestorCategoria",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGUIMNTOCAMPOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SeguimientoBean segtoBean= new SeguimientoBean();
					segtoBean.setSupervisorID(resultSet.getString(1));
					segtoBean.setNombreUsuario(resultSet.getString(2));
					return segtoBean;
				}
			});
			seguimientoBean = matches.size() > 0 ? (SeguimientoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de seguimientos", e);
		}
		return seguimientoBean;
	}

	/* Consuta de Supervisores por Gestor */
	public SeguimientoBean conSupervisorGestor(int tipoConsulta, SeguimientoBean seguimiento) {
		SeguimientoBean seguimientoBean = null;
		try{
			//Query con el Store Procedure
			String query = "call SEGUIMNTOCAMPOCON(?,?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {
								seguimiento.getEjecutorID(),
								seguimiento.getCategoriaID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SeguimientoDAO.conSupervisorGestor",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGUIMNTOCAMPOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SeguimientoBean segtoBean= new SeguimientoBean();
					segtoBean.setSupervisorID(resultSet.getString(1));
					segtoBean.setNombreUsuario(resultSet.getString(2));
					return segtoBean;
				}
			});
			seguimientoBean = matches.size() > 0 ? (SeguimientoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de seguimientos", e);
		}
		return seguimientoBean;
	}

	public List consultaPlazas(SeguimientoBean seguimiento, int tipoConsulta) {
		List seguimientoBean = null;
		try{
			//Query con el Store Procedure
			String query = "call SEGTOXPLAZASCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	seguimiento.getSeguimientoID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SeguimientoDAO.consultaPlazas",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOXPLAZASCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SeguimientoBean segtoBean= new SeguimientoBean();
					segtoBean.setSeguimientoID(resultSet.getString(1));
					segtoBean.setPlazaID(resultSet.getString(2));
					return segtoBean;
				}
			});
			seguimientoBean = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de seguimientos", e);
		}
		return seguimientoBean;
	}

	public List consultaSucursal(SeguimientoBean seguimiento, int tipoConsulta) {
		List seguimientoBean = null;
		try{
			//Query con el Store Procedure
			String query = "call SEGTOXSUCURSALCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	seguimiento.getSeguimientoID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SeguimientoDAO.consultaPlazas",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOXSUCURSALCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SeguimientoBean segtoBean= new SeguimientoBean();
					segtoBean.setSeguimientoID(resultSet.getString(1));
					segtoBean.setSucursalID(resultSet.getString(2));
					return segtoBean;
				}
			});
			seguimientoBean = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de seguimientos", e);
		}
		return seguimientoBean;
	}

	public List consultaEjecutivo(SeguimientoBean seguimiento, int tipoConsulta) {
		List seguimientoBean = null;
		try{
			//Query con el Store Procedure
			String query = "call SEGTOXEJECUTIVOCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	seguimiento.getSeguimientoID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SeguimientoDAO.consultaPlazas",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOXEJECUTIVOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SeguimientoBean segtoBean= new SeguimientoBean();
					segtoBean.setSeguimientoID(resultSet.getString(1));
					segtoBean.setEjecutivoID(resultSet.getString(2));
					return segtoBean;
				}
			});
			seguimientoBean = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de seguimientos", e);
		}
		return seguimientoBean;
	}

	public List consultaFondeador(SeguimientoBean seguimiento, int tipoConsulta) {
		List seguimientoBean = null;
		try{
			//Query con el Store Procedure
			String query = "call SEGTOFONDEOCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	seguimiento.getSeguimientoID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SeguimientoDAO.consultaPlazas",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOFONDEOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SeguimientoBean segtoBean= new SeguimientoBean();
					segtoBean.setSeguimientoID(resultSet.getString(1));
					segtoBean.setFondeadorID(resultSet.getString(2));
					return segtoBean;
				}
			});
			seguimientoBean = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de seguimientos", e);
		}
		return seguimientoBean;
	}

	public List consultaSegtoProducto(SeguimientoBean segtoBean, int tipoConsulta){
		List segtoProductos = null ;
		try{
			String query = "call SEGTOPRODUCTOCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					segtoBean.getSeguimientoID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"SeguimientoDAO.consultaSegtoProducto",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOPRODUCTOCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SeguimientoBean segto = new SeguimientoBean();
					segto.setProductoID(resultSet.getString(1));
					return segto;
				}
			});
			segtoProductos =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de seguimiento por producto", e);
		}
		return segtoProductos;
	}

	public List consultaSegtoClasifica(SeguimientoBean segtoBean, int tipoConsulta){
		List segtoSeleccion= null ;
		try{
			String query = "call SEGTOCLASIFCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					segtoBean.getSeguimientoID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"SeguimientoDAO.consultaSegtoProducto",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOCLASIFCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SeguimientoBean segto = new SeguimientoBean();
					segto.setClaCondicion(resultSet.getString(1));
					segto.setClaOperador(resultSet.getString(2));
					return segto;
				}
			});
			segtoSeleccion =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de seguimiento por clasificacion", e);
		}
		return segtoSeleccion;
	}


	public List consultaSegtoPrograma(SeguimientoBean segtoBean, int tipoConsulta){
		List segtoSeleccion= null ;
		try{
			String query = "call SEGTOPROGRACON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					segtoBean.getSeguimientoID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"SeguimientoDAO.consultaSegtoProducto",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOPROGRACON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SeguimientoBean segto = new SeguimientoBean();
					segto.setPeriodicidad(resultSet.getString(1));
					segto.setAvanceCredito(resultSet.getString(2));
					segto.setDiasOtorga(resultSet.getString(3));
					segto.setDiasAntLiq(resultSet.getString(4));
					segto.setDiasAntCuota(resultSet.getString(5));
					segto.setMinUltSegto(resultSet.getString(6));
					segto.setMaxUltSegto(resultSet.getString(7));
					segto.setPlazoMaximo(resultSet.getString(8));
					segto.setDiaMes(resultSet.getString(9));
					segto.setDiaSemana(resultSet.getString(10));
					segto.setDiaHabil(resultSet.getString(11));
					return segto;
				}
			});
			segtoSeleccion =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de seguimiento por criterios", e);
		}
		return segtoSeleccion;
	}

	public List consultaSegtoCriterio(SeguimientoBean segtoBean, int tipoConsulta){
		List segtoSeleccion= null ;
		try{
			String query = "call SEGTOCRITERIOCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					segtoBean.getSeguimientoID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"SeguimientoDAO.consultaSegtoProducto",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOCRITERIOCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SeguimientoBean segto = new SeguimientoBean();
					segto.setCriterio(resultSet.getString(1));
					segto.setCompuerta(resultSet.getString(2));
					segto.setCondici1(resultSet.getString(3));
					segto.setOperador(resultSet.getString(4));
					segto.setCondici2(resultSet.getString(5));
					segto.setConOpc(resultSet.getString(6));
					return segto;
				}
			});
			segtoSeleccion =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de seguimiento por criterios", e);
		}
		return segtoSeleccion;
	}

	/* Lista de Seguimientos*/
	public List lista(SeguimientoBean seguimiento, int tipoLista) {
		//Query con el Store Procedure
		String query = "call SEGUIMNTOCAMPOLIS(?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	seguimiento.getSeguimientoID(),
								Constantes.ENTERO_CERO,
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGUIMNTOCAMPOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SeguimientoBean segtoBean= new SeguimientoBean();
				segtoBean.setSeguimientoID(resultSet.getString(1));
				segtoBean.setDescripcion(resultSet.getString(2));
				return segtoBean;
			}
		});
		return matches;
	}

	/* Lista de Gestores por Categoria*/
	public List listaGestorCategoria(SeguimientoBean seguimiento, int tipoLista) {
		//Query con el Store Procedure
		String query = "call SEGUIMNTOCAMPOLIS(?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								seguimiento.getEjecutorID(),
								seguimiento.getCategoriaID(),
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGUIMNTOCAMPOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SeguimientoBean segtoBean= new SeguimientoBean();
				segtoBean.setUsuarioID(resultSet.getString(1));
				segtoBean.setNombreUsuario(resultSet.getString(2));
				return segtoBean;
			}
		});
		return matches;
	}


	// consulta para reporte en excel de Seguimiento de Campo
			public List consultaRepSegtoExcel(final SeguimientoBean seguimiento, int tipoLista){
				List ListaResultado=null;
				try{
				String query = "call SEGUIMIENTOCAMPOREP(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?)";

				Object[] parametros ={
									Utileria.convierteFecha(seguimiento.getFechaInicio()),
									Utileria.convierteFecha(seguimiento.getFechaFin()),
									Utileria.convierteEntero(seguimiento.getCategoriaID()),
									Utileria.convierteEntero(seguimiento.getPlazaID()),
									Utileria.convierteEntero(seguimiento.getSucursalID()),
									Utileria.convierteEntero(seguimiento.getProdCreditoID()),
									Utileria.convierteEntero(seguimiento.getGestorDesc()),
									Utileria.convierteEntero(seguimiento.getSupervisorID()),
									Utileria.convierteEntero(seguimiento.getResultadoID()),
									Utileria.convierteEntero(seguimiento.getRecomendacionID()),
									Utileria.convierteEntero(seguimiento.getMunicipioID()),
									tipoLista,

						    		parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									parametrosAuditoriaBean.getNombrePrograma(),
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGUIMIENTOCAMPOREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						RepSeguimientoBean repSeguimiento= new RepSeguimientoBean();
						repSeguimiento.setSegtoPrograID(resultSet.getString("SegtoPrograID"));
						repSeguimiento.setFechaRegistro(resultSet.getString("FechaRegistro"));
						repSeguimiento.setCreditoID(resultSet.getString("CreditoID"));
						repSeguimiento.setNombreCompleto(resultSet.getString("NombreCompleto"));
						repSeguimiento.setGrupoID(resultSet.getString("GrupoID"));
						repSeguimiento.setNombreGrupo(resultSet.getString("NombreGrupo"));
						repSeguimiento.setFechaCaptura(resultSet.getString("FechaCaptura"));
						repSeguimiento.setFechaProgramada(resultSet.getString("FechaProgramada"));
						repSeguimiento.setFechaInicioSegto(resultSet.getString("FechaInicioSegto"));
						repSeguimiento.setFechaFinalSegto(resultSet.getString("FechaFinalSegto"));
						repSeguimiento.setComentario(resultSet.getString("Comentario"));
						repSeguimiento.setResultado(resultSet.getString("Resultado"));
						repSeguimiento.setRecomendacion1(resultSet.getString("Recomendacion1"));
						repSeguimiento.setRecomendacion2(resultSet.getString("Recomendacion2"));
						repSeguimiento.setEstatusRealiza(resultSet.getString("EstatusRealiza"));
						repSeguimiento.setHora(resultSet.getString("HoraEmision"));


						return repSeguimiento ;
					}
				});
				ListaResultado= matches;
				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reporte de seguimiento de campo", e);
				}
				return ListaResultado;
			}

			// consulta para reporte en excel de Eficacia de Seguimiento de Campo
						public List consultaRepEficaciaSegtoExcel(final SeguimientoBean seguimiento, int tipoLista){
							List ListaResultado=null;
							try{
							String query = "call SEGTOCAMPOEFICACIAREP(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,  ?,?,?,?)";

							Object[] parametros ={
												Utileria.convierteFecha(seguimiento.getFechaInicio()),
												Utileria.convierteFecha(seguimiento.getFechaFin()),
												Utileria.convierteFecha(seguimiento.getFechaInicioSeg()),
												Utileria.convierteFecha(seguimiento.getFechaFinSeg()),
												Utileria.convierteEntero(seguimiento.getCategoriaID()),
												Utileria.convierteEntero(seguimiento.getPlazaID()),
												Utileria.convierteEntero(seguimiento.getSucursalID()),
												Utileria.convierteEntero(seguimiento.getProdCreditoID()),
												Utileria.convierteEntero(seguimiento.getGestorDesc()),
												Utileria.convierteEntero(seguimiento.getTipoGestorID()),
												Utileria.convierteEntero(seguimiento.getSupervisorID()),
												Utileria.convierteEntero(seguimiento.getResultadoID()),
												Utileria.convierteEntero(seguimiento.getRecomendacionID()),
												Utileria.convierteEntero(seguimiento.getMunicipioID()),
												seguimiento.getSelecProgramada(),
												seguimiento.getSelecSeguimiento(),
												tipoLista,

									    		parametrosAuditoriaBean.getEmpresaID(),
												parametrosAuditoriaBean.getUsuario(),
												parametrosAuditoriaBean.getFecha(),
												parametrosAuditoriaBean.getDireccionIP(),
												parametrosAuditoriaBean.getNombrePrograma(),
												parametrosAuditoriaBean.getSucursal(),
												Constantes.ENTERO_CERO};
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOCAMPOEFICACIAREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
								public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
									RepEficaciaSeguimientoBean eficaciaSeguimiento= new RepEficaciaSeguimientoBean();
									eficaciaSeguimiento.setSegtoPrograID(resultSet.getString("SegtoPrograID"));
									eficaciaSeguimiento.setFechaRegistro(resultSet.getString("FechaRegistro"));
									eficaciaSeguimiento.setCreditoID(resultSet.getString("CreditoID"));
									eficaciaSeguimiento.setNombreCompleto(resultSet.getString("NombreCompleto"));
									eficaciaSeguimiento.setGrupoID(resultSet.getString("GrupoID"));
									eficaciaSeguimiento.setNombreGrupo(resultSet.getString("NombreGrupo"));
									eficaciaSeguimiento.setFechaCaptura(resultSet.getString("FechaCaptura"));
									eficaciaSeguimiento.setFechaProgramada(resultSet.getString("FechaProgramada"));
									eficaciaSeguimiento.setFechaInicioSegto(resultSet.getString("FechaInicioSegto"));
									eficaciaSeguimiento.setFechaFinalSegto(resultSet.getString("FechaFinalSegto"));
									eficaciaSeguimiento.setComentario(resultSet.getString("Comentario"));
									eficaciaSeguimiento.setResultado(resultSet.getString("Resultado"));
									eficaciaSeguimiento.setRecomendacion1(resultSet.getString("Recomendacion1"));
									eficaciaSeguimiento.setRecomendacion2(resultSet.getString("Recomendacion2"));
									eficaciaSeguimiento.setEstatusRealiza(resultSet.getString("EstatusCredito"));
									eficaciaSeguimiento.setHora(resultSet.getString("HoraEmision"));
									eficaciaSeguimiento.setFechaPromesaPago(resultSet.getString("FechaPromPago"));
									eficaciaSeguimiento.setMontoPromesaPago(resultSet.getString("MontoPromPago"));
									eficaciaSeguimiento.setFechaRealPago(resultSet.getString("FechaUltimoPago"));
									eficaciaSeguimiento.setMontoRealPago(resultSet.getString("MontoTotalPagado"));
									eficaciaSeguimiento.setDiasAtraso(resultSet.getString("DiasAtraso"));

									return eficaciaSeguimiento ;
								}
							});
							ListaResultado= matches;
							}catch(Exception e){
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reporte de eficacia de seguimiento de campo", e);
							}
							return ListaResultado;
						}

	}
