package pld.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import pld.bean.RemesasWSBean;

public class RemesasWSDAO extends BaseDAO{
	
	public RemesasWSDAO(){
		super();
	}
	
	// Lista de Referencia de Remesas
	public List listaReferenciaRemesas(RemesasWSBean remesasBean, int tipoLista){
		List listaReferencia = null;
		try{
			String query = "call REMESASWSLIS(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {	
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					remesasBean.getDescripcion(),
					Constantes.STRING_VACIO,
					
					Constantes.STRING_VACIO,
					tipoLista,
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"RemesasDAO.listaReferenciaRemesas",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
					};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call REMESASWSLIS(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RemesasWSBean remesasBean = new RemesasWSBean();
					remesasBean.setRemesaFolioID(resultSet.getString("RemesaFolioID"));
					remesasBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					remesasBean.setEstatus(resultSet.getString("Estatus"));
					
					return remesasBean;
				}
			});
			listaReferencia = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Referencia de Remesas.", e);
		}	
		return listaReferencia;		
	}

}
