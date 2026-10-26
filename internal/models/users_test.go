package models

import (
	"testing"

	"github.com/arzamaskov/snippetbox/internal/assert"
)

func TestUserModelExists(t *testing.T) {
	if testing.Short() {
		t.Skip("models: skipping integration test")
	}

	tests := []struct {
		name   string
		userId int
		want   bool
	}{
		{
			name:   "Valid ID",
			userId: 1,
			want:   true,
		},
		{
			name:   "Zero ID",
			userId: 0,
			want:   false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			db := newTestDB(t)
			m := UserModel{db}

			exists, err := m.Exists(tt.userId)

			assert.Equal(t, exists, tt.want)
			assert.NilError(t, err)
		})
	}
}

func TestUserModelPasswordUpdate(t *testing.T) {
	if testing.Short() {
		t.Skip("models: skipping integration test")
	}

	db := newTestDB(t)
	m := UserModel{DB: db}
	assert.NilError(t, m.Insert("Bob", "bob@example.com", "currentpassword"))
	var id int
	assert.NilError(t, db.QueryRow("SELECT id FROM users WHERE email = ?", "bob@example.com").Scan(&id))

	err := m.PasswordUpdate(id, "wrong-password", "newpassword")
	assert.Equal(t, err, ErrInvalidCredentials)
	_, err = m.Authenticate("bob@example.com", "currentpassword")
	assert.NilError(t, err)

	err = m.PasswordUpdate(id, "currentpassword", "newpassword")
	assert.NilError(t, err)
	_, err = m.Authenticate("bob@example.com", "currentpassword")
	assert.Equal(t, err, ErrInvalidCredentials)
	_, err = m.Authenticate("bob@example.com", "newpassword")
	assert.NilError(t, err)

	err = m.PasswordUpdate(id+100, "whatever", "anotherpassword")
	assert.Equal(t, err, ErrNoRecord)
}
