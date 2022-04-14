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


import tarjetas.bean.BitacoraEstatusTarDebBean;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class BitacoraEstatusTarDebDAO  extends BaseDAO{
	public BitacoraEstatusTarDebDAO() {
		super();
	}
	
	public List ListaPrincipal(int tipoLista,BitacoraEstatusTarDebBean bitacoraEstatusTarDebBean ) {
		String query = "call BITACORATARDEBLIS(?,?,    ?,?,?, ?,?,?,?);";
		Object[] parametros = {
				bitacoraEstatusTarDebBean.getTarjetaID(),
			
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"BITACORATARDEBLIS.listaPrincipal",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BITACORATARDEBLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {

				BitacoraEstatusTarDebBean bitacoraEstatusTarDebBean = new BitacoraEstatusTarDebBean();
				bitacoraEstatusTarDebBean.setFecha(resultSet.getString(1));
				bitacoraEstatusTarDebBean.setTipoEvento(resultSet.getString(2));
				bitacoraEstatusTarDebBean.setMotivo(resultSet.getString(3));
	       		bitacoraEstatusTarDebBean.setDescripcion(resultSet.getString(4));
	
		
				return bitacoraEstatusTarDebBean;

			}
		});
		return matches;
	}
}
