package tarjetas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
 
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import tarjetas.bean.TarDebOperaAclaranBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class TarDebOperaAclaraDAO  extends BaseDAO{
	public TarDebOperaAclaraDAO() {
		super();
	}

	/* Lista tipo de tarjetas de Debito */
	public List listaAclaracion(TarDebOperaAclaranBean tarDebOperaAclaranBean, int tipoLista) {
		List listaAclaracion=null;
		try{
		String query = "call TARDEBOPEACLARALIS(?,?,?, ?,?,?, ?,?,?);";
		Object[] parametros = { 
								tarDebOperaAclaranBean.getTipoAclaracionID(),
								tipoLista,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"listaAclaracion",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO 																								
								
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBOPEACLARALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TarDebOperaAclaranBean operacionAclaracion = new TarDebOperaAclaranBean();
				operacionAclaracion.setTipoAclaracionID(resultSet.getString("TipoAclaraID"));
				operacionAclaracion.setOperacion(resultSet.getString("OpeAclaraID"));
				operacionAclaracion.setDescripcion(resultSet.getString("Descripcion"));
				operacionAclaracion.setComercio(resultSet.getString("ComercioObl"));
				operacionAclaracion.setCajero(resultSet.getString("CajeroObl"));
				
				return operacionAclaracion;
			}
		});

		listaAclaracion= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la operacion de aclaraciones", e);
		}	
		return listaAclaracion;	
	}
	
	/* Lista tipo de tarjetas de Debito */
	public List listaCreAclaracion(TarDebOperaAclaranBean tarDebOperaAclaranBean, int tipoLista) {
		List listaAclaracion=null;
		try{
		String query = "call TARDEBOPEACLARALIS(?,?,?, ?,?,?, ?,?,?);";
		Object[] parametros = { 
								tarDebOperaAclaranBean.getTipoAclaracionID(),
								tipoLista,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"listaAclaracion",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO 																								
								
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBOPEACLARALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TarDebOperaAclaranBean operacionAclaracion = new TarDebOperaAclaranBean();
				operacionAclaracion.setTipoAclaracionID(resultSet.getString("TipoAclaraID"));
				operacionAclaracion.setOperacion(resultSet.getString("OpeAclaraID"));
				operacionAclaracion.setDescripcion(resultSet.getString("Descripcion"));
				operacionAclaracion.setComercio(resultSet.getString("ComercioObl"));
				operacionAclaracion.setCajero(resultSet.getString("CajeroObl"));
				
				return operacionAclaracion;
			}
		});

		listaAclaracion= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la operacion de aclaraciones", e);
		}	
		return listaAclaracion;	
	}
}
