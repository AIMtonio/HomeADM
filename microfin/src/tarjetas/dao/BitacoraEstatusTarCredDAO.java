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

import tarjetas.bean.BitacoraEstatusTarCredBean;




import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class BitacoraEstatusTarCredDAO  extends BaseDAO{
	public BitacoraEstatusTarCredDAO() {
		super();
	}
	
	public List ListaPrincipal(int tipoLista,BitacoraEstatusTarCredBean bitacoraEstatusTarCredBean ) {
		String query = "call TC_BITACORALIS(?,?,    ?,?,?, ?,?,?,?);";
		Object[] parametros = {
				bitacoraEstatusTarCredBean.getTarjetaID(),
			
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"TC_BITACORALIS.listaPrincipal",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TC_BITACORALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {

				BitacoraEstatusTarCredBean bitacoraEstatusTarCredBean = new BitacoraEstatusTarCredBean();
				bitacoraEstatusTarCredBean.setFecha(resultSet.getString(1));
				bitacoraEstatusTarCredBean.setTipoEvento(resultSet.getString(2));
				bitacoraEstatusTarCredBean.setMotivo(resultSet.getString(3));
				bitacoraEstatusTarCredBean.setDescripcion(resultSet.getString(4));
	
		
				return bitacoraEstatusTarCredBean;

			}
		});
		return matches;
	}
}
